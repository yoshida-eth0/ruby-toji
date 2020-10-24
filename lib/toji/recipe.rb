require 'toji/recipe/step'
require 'toji/recipe/action'
require 'toji/recipe/ab_expect'

module Toji
  module Recipe
    attr_accessor :steps
    attr_accessor :actions
    attr_accessor :has_moto
    attr_accessor :has_moromi
    attr_accessor :ab_coef
    attr_accessor :ab_expects

    def scale(rice_total)
      ratio = rice_total / steps.map(&:rice_total).sum
      new_steps = steps.map {|step|
        step * ratio
      }

      self.class.new.tap {|o|
        o.steps = new_steps
        o.actions = actions.deep_dup
        o.has_moto = has_moto
        o.has_moromi = has_moromi
        o.ab_coef = ab_coef
        o.ab_expects = ab_expects.deep_dup
      }
    end

    def round(ndigit=0, mini_ndigit=nil, half: :up)
      new_steps = steps.map {|step|
        step.round(ndigit, mini_ndigit, half: half)
      }

      self.class.new.tap {|o|
        o.steps = new_steps
        o.actions = actions.deep_dup
        o.has_moto = has_moto
        o.has_moromi = has_moromi
        o.ab_coef = ab_coef
        o.ab_expects = ab_expects.deep_dup
      }
    end

    # 総米の累計
    def cumulative_rice_totals
      rice_total = steps.map(&:rice_total)

      rice_total.map.with_index {|x,i|
        rice_total[0..i].inject(&:+)
      }
    end

    # 酒母歩合の累計
    def cumulative_moto_ratios
      rice_total = steps.map(&:rice_total)
      moto = rice_total.first

      rice_total.map.with_index {|x,i|
        moto / rice_total[0..i].inject(&:+)
      }
    end

    # 酒母歩合
    #
    # 7%が標準である
    # 汲水歩合が大きい高温糖化酒母では6%程度である
    #
    # 出典: 酒造教本 P96
    def moto_ratio
      cumulative_moto_ratios.last || 0.0
    end

    # 白米比率
    #
    # 発酵型と白米比率
    #   発酵の型    酒母  添  仲  留  特徴
    #   湧き進め型     1   2   4   6  短期醪、辛口、軽快な酒質
    #   湧き抑え型     1   2   4   7  長期醪、甘口、おだやかな酒質
    #
    # 出典: 酒造教本 P95
    def rice_ratios
      steps.map {|step|
        step.rice_total / steps.first.rice_total
      }
    end

    def table_data
      headers = [""] + steps.map.with_index{|s,i| :"step#{i}"} + [:total]
      keys = [[:rice_total, :itself], [:kake, :weight], [:koji, :weight], [:alcohol, :weight], [:water, :weight], [:lactic_acid, :weight]]

      cells = [keys.map(&:first)]
      cells += steps.map {|step|
        keys.map {|k1, k2|
          step.send(k1)&.send(k2)
        }
      }
      cells << keys.map {|k1, k2|
        steps.map(&k1).compact.map(&k2).compact.sum
      }

      cells = cells.map {|cell|
        cell.map {|c|
          case c
          when NilClass
            ""
          when 0
            ""
          else
            c
          end
        }
      }

      {header: headers, rows: cells.transpose}
    end

    def table
      data = table_data

      Plotly::Plot.new(
        data: [{
          type: :table,
          header: {
            values: data[:header]
          },
          cells: {
            values: data[:rows].transpose
          },
        }],
        layout: {
        }
      )
    end
  end
end
