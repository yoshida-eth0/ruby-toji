module Toji
  module Recipe
    class ThreeStepMashing

      attr_reader :steps
      attr_reader :yeast

      def initialize(steps, yeast_rate)
        @steps = steps

        @yeast_rate = yeast_rate
        weight_total = @steps.map(&:weight_total).sum
        @yeast = Ingredient::Yeast.new(weight_total, rate: yeast_rate)
      end

      def scale(rice_total, yeast_rate=@yeast_rate)
        rate = rice_total / @steps.map(&:rice_total).sum
        new_steps = @steps.map {|step|
          step * rate
        }

        self.class.new(new_steps, yeast_rate)
      end

      def round(ndigit=0, half: :up)
        new_steps = @steps.map {|step|
          step.round(ndigit, half: half)
        }
        self.class.new(new_steps, @yeast_rate)
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


      TEMPLATES = {
        # 酒造教本による標準型仕込配合
        # 出典: 酒造教本 P97
        sokujo_textbook: new(
          [
            Step.new(
              rice: 45,
              koji: 20,
              water: 70,
              lactic_acid: 70*6.85/1000
            ),
            Step.new(
              rice: 100,
              koji: 40,
              water: 130
            ),
            Step.new(
              rice: 215,
              koji: 60,
              water: 330
            ),
            Step.new(
              rice: 360,
              koji: 80,
              water: 630
            ),
          ],
          YeastRate::RED_STAR,
        ),
        # 灘における仕込配合の平均値
        # 出典: http://www.nada-ken.com/main/jp/index_shi/234.html
        sokujo_nada: new(
          [
            Step.new(
              rice: 93,
              koji: 47,
              water: 170,
              lactic_acid: 170*6.85/1000
            ),
            Step.new(
              rice: 217,
              koji: 99,
              water: 270
            ),
            Step.new(
              rice: 423,
              koji: 143,
              water: 670
            ),
            Step.new(
              rice: 813,
              koji: 165,
              water: 1330
            ),
          ],
          YeastRate::RED_STAR,
        ),
      }.freeze
    end
  end
end
