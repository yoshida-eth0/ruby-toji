require 'toji/recipe/step'

module Toji
  module Recipe
    attr_accessor :steps

    def scale(rice_total)
      rate = rice_total / steps.map(&:rice_total).sum
      new_steps = steps.map {|step|
        step * rate
      }

      self.class.new.tap {|o|
        o.steps = new_steps
      }
    end

    def round(ndigit=0, mini_ndigit=nil, half: :up)
      new_steps = steps.map {|step|
        step.round(ndigit, mini_ndigit, half: half)
      }

      self.class.new.tap {|o|
        o.steps = new_steps
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
    def cumulative_shubo_rates
      rice_total = steps.map(&:rice_total)
      shubo = rice_total.first

      rice_total.map.with_index {|x,i|
        shubo / rice_total[0..i].inject(&:+)
      }
    end

    # 酒母歩合
    #
    # 7%が標準である
    # 汲水歩合が大きい高温糖化酒母では6%程度である
    #
    # 出典: 酒造教本 P96
    def shubo_rate
      cumulative_shubo_rates.last || 0.0
    end

    # 白米比率
    #
    # 発酵型と白米比率
    #   発酵の型    酒母  添  仲  留  特徴
    #   湧き進め型     1   2   4   6  短期醪、辛口、軽快な酒質
    #   湧き抑え型     1   2   4   7  長期醪、甘口、おだやかな酒質
    #
    # 出典: 酒造教本 P95
    def rice_rates
      steps.map {|step|
        step.rice_total / steps.first.rice_total
      }
    end

    def table_data
      headers = [""] + steps.map(&:name) + [:total]
      keys = [:rice_total, :kake, :koji, :alcohol, :water, :lactic_acid]

      cells = [keys]
      cells += steps.map {|step|
        [step.rice_total, step.kake, step.koji, step.alcohol, step.water, step.lactic_acid]
      }
      cells << keys.map {|key|
        steps.map(&key).compact.sum
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
