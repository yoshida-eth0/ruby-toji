module Toji
  module Recipe
    class ThreeStepMashing

      attr_reader :steps
      attr_reader :yeast

      attr_accessor :moto_days
      attr_accessor :odori_days

      def initialize(steps, yeast_rate, moto_days: 1, odori_days: 1)
        @steps = steps

        @yeast_rate = yeast_rate
        weight_total = @steps.map(&:weight_total).sum
        @yeast = Ingredient::Yeast.new(weight_total, rate: yeast_rate)

        @moto_days = moto_days
        @odori_days = odori_days
      end

      def scale(rice_total, yeast_rate=@yeast_rate)
        rate = rice_total / @steps.map(&:rice_total).sum
        new_steps = @steps.map {|step|
          step * rate
        }

        self.class.new(new_steps, yeast_rate, moto_days: @moto_days, odori_days: @odori_days)
      end

      def round(ndigit=0, half: :up)
        new_steps = @steps.map {|step|
          step.round(ndigit, half: half)
        }
        self.class.new(new_steps, @yeast_rate, moto_days: @moto_days, odori_days: @odori_days)
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
        cumulative_shubo_rates.last
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

      def table_data
        headers = [""] + @steps.map(&:name) + [:total]
        keys = [:rice_total, :rice, :koji, :alcohol, :water, :lactic_acid]

        cells = [keys]
        cells += @steps.map {|step|
          [step.rice_total, step.rice, step.koji, step.alcohol, step.water, step.lactic_acid]
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

        {header: headers, cells: cells}
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
              values: data[:cells]
            },
          }],
          layout: {
          }
        )
      end


      # 乳酸は汲水100L当たり比重1.21の乳酸(90%乳酸と称される)を650〜720ml添加する。
      # ここでは間をとって685mlとする
      #
      # 出典: 酒造教本 P38
      TEMPLATES = {
        # 酒造教本による標準型仕込配合
        # 出典: 酒造教本 P97
        sokujo_textbook: new(
          [
            Step.new(
              name: :moto,
              rice: 45,
              koji: 20,
              water: 70,
              lactic_acid: 70*6.85/1000
            ),
            Step.new(
              name: :soe,
              rice: 100,
              koji: 40,
              water: 130
            ),
            Step.new(
              name: :naka,
              rice: 215,
              koji: 60,
              water: 330
            ),
            Step.new(
              name: :tome,
              rice: 360,
              koji: 80,
              water: 630
            ),
            Step.new(
              name: :yodan,
              rice: 80,
              water: 120
            ),
          ],
          YeastRate::RED_STAR,
          moto_days: 14,
          odori_days: 1,
        ),
        # 灘における仕込配合の平均値
        # 出典: http://www.nada-ken.com/main/jp/index_shi/234.html
        sokujo_nada: new(
          [
            Step.new(
              name: :moto,
              rice: 93,
              koji: 47,
              water: 170,
              lactic_acid: 170*6.85/1000
            ),
            Step.new(
              name: :soe,
              rice: 217,
              koji: 99,
              water: 270
            ),
            Step.new(
              name: :naka,
              rice: 423,
              koji: 143,
              water: 670
            ),
            Step.new(
              name: :tome,
              rice: 813,
              koji: 165,
              water: 1330
            ),
            Step.new(
              name: :alcohol,
              alcohol: 900
            ),
          ],
          YeastRate::RED_STAR,
          moto_days: 14,
          odori_days: 1,
        ),
        # 簡易酒母省略仕込
        # 出典: https://www.jstage.jst.go.jp/article/jbrewsocjapan1915/60/11/60_11_999/_article/-char/ja/
        simple_sokujo_himeno: new(
          [
            Step.new(
              name: :moto,
              rice: 0,
              koji: 70,
              water: 245,
              lactic_acid: 1.6
            ),
            Step.new(
              name: :soe,
              rice: 130,
              koji: 0,
              water: 0
            ),
            Step.new(
              name: :naka,
              rice: 300,
              koji: 100,
              water: 400
            ),
            Step.new(
              name: :tome,
              rice: 490,
              koji: 110,
              water: 800
            ),
            Step.new(
              name: :yodan,
              water: 255
            ),
          ],
          YeastRate::RED_STAR,
          moto_days: 1,
          odori_days: 2,
        ),
      }.freeze
    end
  end
end
