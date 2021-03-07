require 'toji/recipe/step'
require 'toji/recipe/action'
require 'toji/recipe/ab_expect'

module Toji
  module Recipe
    # @dynamic steps
    # @dynamic actions
    # @dynamic ab_coef
    # @dynamic ab_expects

    def ingredients(&block)
      Enumerator.new do|y|
        steps&.each {|step|
          step.ingredients.each {|ingredient|
            y << [step, ingredient]
          }
        }
      end.each(&block)
    end

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

    def compact!
      steps.map(&:compact!)
      steps.select! {|step| 0<step.ingredients.to_a.length}

      ab_expects.select! {|ab| ab.alcohol && ab.nihonshudo}
      ab_expects.uniq! {|ab| [ab.alcohol, ab.nihonshudo]}

      self
    end

    def compact
      Utils.check_dup(self)

      dst = self.dup
      dst.compact!
    end


    # 仕込み全体の集計値

    # 総米
    def rice_total
      steps.map(&:rice_total).sum.to_f
    end

    # 麹歩合
    # 原料白米に占める麹米の割合
    # 留め仕込みまでの総米重量の20〜22%が標準である
    # なお、留め仕込みまでの麹歩合が20%を下回ると蒸米の溶解糖化に影響が出るので注意がいる
    # 出典: 酒造教本 P95
    def koji_ratio
      val = steps.map(&:koji_total).sum.to_f / rice_total
      val.nan? ? 0.0 : val
    end

    # 汲水歩合
    #
    # 酒母: 110%が標準、高温糖化酒母は150〜180%
    # 添:   85〜100%の範囲で90%が標準、湧き進め型は歩合が高い
    # 仲:   120%が標準
    # 留:   130〜150%の範囲
    # 全体: 留までの総米に対し120〜130%、標準は125%、高級酒は130〜145%である
    #
    # 出典: 酒造教本 P96
    def water_ratio
      val = steps.map(&:water_total).sum.to_f / rice_total
      val.nan? ? 0.0 : val
    end

    # 酒母歩合
    #
    # 7%が標準である
    # 汲水歩合が大きい高温糖化酒母では6%程度である
    #
    # 出典: 酒造教本 P96
    def moto_ratio
      moto_ratios.last || 0.0
    end

    # 麹米精米歩合
    def koji_polishing_ratio
      kojis = steps.flat_map{|step| step.kojis}.select{|koji| 0<koji.weight}
      if kojis.length==0 || kojis.find{|koji| !koji.polishing_ratio}
        Float::NAN
      else
        ratio_sum = kojis.map{|koji| koji.polishing_ratio * koji.weight}.sum.to_f
        ratio_sum / steps.map(&:koji_total).sum.to_f
      end
    end

    # 掛米精米歩合
    def kake_polishing_ratio
      kakes = steps.flat_map{|step| step.kakes}.select{|kake| 0<kake.weight}
      if kakes.length==0 || kakes.find{|kake| !kake.polishing_ratio}
        Float::NAN
      else
        ratio_sum = kakes.map{|kake| kake.polishing_ratio * kake.weight}.sum.to_f
        ratio_sum / steps.map(&:kake_total).sum.to_f
      end
    end


    # 累計

    def cumulate(key)
      values = steps.map(&key)

      values.map.with_index {|x,i|
        values[0..i].sum
      }
    end

    # 総米の累計
    def cumulative_rice_totals
      cumulate(:rice_total)
    end

    # 麹歩合の累計
    def cumulative_koji_ratios
      rice_totals = cumulate(:rice_total)
      koji_totals = cumulate(:koji_total)

      rice_totals.map.with_index {|rice_total,i|
        koji_totals[i] / rice_total
      }
    end

    # 汲水歩合の累計
    def cumulative_water_ratios
      rice_totals = cumulate(:rice_total)
      water_totals = cumulate(:water_total)

      rice_totals.map.with_index {|rice_total,i|
        water_totals[i] / rice_total
      }
    end


    # 比率

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

    # 総米の割合
    def rice_total_percentages
      rice_totals = steps.map(&:rice_total)
      total = rice_totals.sum

      rice_totals.map {|rice_total|
        rice_total / total
      }
    end

    # 酒母歩合の累計
    def moto_ratios
      rice_total = steps.map(&:rice_total)
      moto = steps.select(&:moto?).map(&:rice_total).sum.to_f

      rice_total.map.with_index {|x,i|
        moto / rice_total[0..i].inject(&:+)
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
