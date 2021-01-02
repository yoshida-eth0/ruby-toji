require 'toji/recipe/step'
require 'toji/recipe/action'
require 'toji/recipe/ab_expect'

module Toji
  module Recipe
    # @dynamic steps
    # @dynamic actions
    # @dynamic ab_coef
    # @dynamic ab_expects

    def scale_rice_total(rice_total)
      ratio = rice_total.to_f / steps.map(&:rice_total).sum
      scale(ratio)
    end

    def scale!(ratio)
      steps.each {|step|
        step.scale!(ratio)
      }
      self
    end

    def scale(ratio)
      Utils.check_dup(self)

      dst = self.dup
      dst.scale!(ratio)
    end

    def round!(ndigit=0, mini_ndigit=nil, half: :up)
      steps.each {|step|
        step.round!(ndigit, mini_ndigit, half: half)
      }
      self
    end

    def round(ndigit=0, mini_ndigit=nil, half: :up)
      Utils.check_dup(self)

      dst = self.dup
      dst.round!(ndigit, mini_ndigit, half: half)
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
      moto = steps.select(&:moto?).map(&:rice_total).sum.to_f

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
      moto = steps.select(&:moto?).map(&:rice_total).sum.to_f

      steps.map {|step|
        step.rice_total / moto
      }
    end

    def table_data
      headers = [""] + steps.map.with_index{|s,i| :"Step#{i}"} + [:total]
      keys = [["RiceTotal", :rice_total], ["Kake", :kakes], ["Koji", :kojis], ["Alcohol", :alcohols], ["Water", :waters], ["LacticAcid", :lactic_acids]]

      cells = [keys.map(&:first)]
      cells += steps.map {|step|
        keys.map(&:last).map {|key|
          vals = step.send(key)
          if Numeric===vals
            vals
          else
            vals.compact.map(&:weight).sum
          end
        }
      }
      cells << keys.map(&:last).map {|key|
        vals = steps.map(&key)
        if Numeric===vals[0]
          vals.sum
        else
          vals.flatten.compact.map(&:weight).sum
        end
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
