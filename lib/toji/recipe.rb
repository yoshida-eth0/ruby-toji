require 'toji/recipe/step'

module Toji
  class Recipe

    attr_reader :steps

    def initialize(steps)
      @steps = steps
    end

    def scale(rice_total)
      rate = rice_total / @steps.map(&:rice_total).sum
      new_steps = @steps.map {|step|
        step * rate
      }

      self.class.new(new_steps)
    end

    def round(ndigit=0, half: :up)
      new_steps = @steps.map {|step|
        step.round(ndigit, half: half)
      }
      self.class.new(new_steps)
    end

    # 内容量の累計
    def cumulative_weight_totals
      weight_total = @steps.map(&:weight_total)

      weight_total.map.with_index {|x,i|
        weight_total[0..i].inject(:+)
      }
    end

    # 総米の累計
    def cumulative_rice_totals
      rice_total = @steps.map(&:rice_total)

      rice_total.map.with_index {|x,i|
        rice_total[0..i].inject(&:+)
      }
    end

    # 酒母歩合の累計
    def cumulative_shubo_rates
      rice_total = @steps.map(&:rice_total)
      shubo = rice_total[0]

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
      @steps.map {|step|
        step.rice_total / @steps[0].rice_total
      }
    end

    def to_h
      {
        steps: steps.map(&:to_h),
        cumulative_rice_totals: cumulative_rice_totals,
        cumulative_shubo_rates: cumulative_shubo_rates,
        shubo_rate: shubo_rate,
        rice_rates: rice_rates,
      }
    end

    def table_data
      headers = [""] + @steps.map(&:name) + [:total]
      keys = [:rice_total, :kake, :koji, :alcohol, :water, :lactic_acid]

      cells = [keys]
      cells += @steps.map {|step|
        [step.rice_total, step.kake, step.koji, step.alcohol, step.water, step.lactic_acid]
      }
      cells << keys.map {|key|
        @steps.map(&key).compact.sum
      }

      cells = cells.map {|cell|
        cell.map {|c|
          if Ingredient::Rice::Base===c
            c = c.raw
          end

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


    # 乳酸は汲水100L当たり比重1.21の乳酸(90%乳酸と称される)を650〜720ml添加する。
    # 添加する酵母の量は、酒母の総米100kg当たり協会酵母アンプル1〜2本である。
    #
    # 出典: 酒造教本 P80
    #
    # ここでは間をとって乳酸は685ml、酵母は1.5本とする。
    TEMPLATES = {
      # 酒造教本による標準型仕込配合
      # 出典: 酒造教本 P97
      sokujo_textbook: new(
        [
          Step.new(
            name: :moto,
            kake: 45,
            koji: 20,
            water: 70,
            lactic_acid: 70/100.0*0.685,
            yeast: (45+20)/100.0*1.5,
            koji_interval_days: 0,
            kake_interval_days: 5,
          ),
          Step.new(
            name: :soe,
            kake: 100,
            koji: 40,
            water: 130,
            koji_interval_days: 14,
            kake_interval_days: 15,
          ),
          Step.new(
            name: :naka,
            kake: 215,
            koji: 60,
            water: 330,
            koji_interval_days: 0,
            kake_interval_days: 2,
          ),
          Step.new(
            name: :tome,
            kake: 360,
            koji: 80,
            water: 630,
            koji_interval_days: 0,
            kake_interval_days: 1,
          ),
          Step.new(
            name: :yodan,
            kake: 80,
            water: 120,
            kake_interval_days: 25,
          ),
        ]
      ),
      # 灘における仕込配合の平均値
      # 出典: http://www.nada-ken.com/main/jp/index_shi/234.html
      sokujo_nada: new(
        [
          Step.new(
            name: :moto,
            kake: 93,
            koji: 47,
            water: 170,
            lactic_acid: 170/100.0*0.685,
            yeast: (93+47)/100.0*1.5,
            koji_interval_days: 0,
            kake_interval_days: 5,
          ),
          Step.new(
            name: :soe,
            kake: 217,
            koji: 99,
            water: 270,
            koji_interval_days: 14,
            kake_interval_days: 15,
          ),
          Step.new(
            name: :naka,
            kake: 423,
            koji: 143,
            water: 670,
            koji_interval_days: 0,
            kake_interval_days: 2,
          ),
          Step.new(
            name: :tome,
            kake: 813,
            koji: 165,
            water: 1330,
            koji_interval_days: 0,
            kake_interval_days: 1,
          ),
          Step.new(
            name: :alcohol,
            alcohol: 900
          ),
        ]
      ),
      # 簡易酒母省略仕込
      # 出典: https://www.jstage.jst.go.jp/article/jbrewsocjapan1915/60/11/60_11_999/_article/-char/ja/
      simple_sokujo_himeno: new(
        [
          Step.new(
            name: :moto,
            kake: 0,
            koji: 70,
            water: 245,
            lactic_acid: 1.6,
            yeast: 5,
            koji_interval_days: 0,
            kake_interval_days: 6,
          ),
          Step.new(
            name: :soe,
            kake: 130,
            koji: 0,
            water: 0,
            koji_interval_days: 0,
            kake_interval_days: 1,
          ),
          Step.new(
            name: :naka,
            kake: 300,
            koji: 100,
            water: 400,
            koji_interval_days: 0,
            kake_interval_days: 2,
          ),
          Step.new(
            name: :tome,
            kake: 490,
            koji: 110,
            water: 800,
            koji_interval_days: 0,
            kake_interval_days: 1,
          ),
          Step.new(
            name: :yodan,
            water: 255
          ),
        ]
      ),
    }.freeze
  end
end
