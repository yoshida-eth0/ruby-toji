module Toji
  module Recipe
    class ThreeStepMashing

      STEP_NAMES = ["酒母", "初添", "仲添", "留添"]

      @@template = [
        Step.new(93, 47, 170),
        Step.new(217, 99, 270),
        Step.new(423, 143, 670),
        Step.new(813, 165, 1330),
      ]
      #@@template = [
      #  Step.new(45, 20, 70),
      #  Step.new(100, 40, 130),
      #  Step.new(215, 60, 330),
      #  Step.new(360, 80, 630),
      #]

      attr_reader :yeast
      attr_reader :lactic_acid
      attr_reader :steps

      def initialize(yeast_cls, lactic_acid_cls, total, template=@@template)
        @total = total
        rate = total / template.map(&:weight_total).sum

        @yeast = yeast_cls.new(total)
        @lactic_acid = lactic_acid_cls.new(total)

        @steps = template.map {|step|
          step * rate
        }
      end

      # 内容量の累計
      def cumulative_weight_totals
        total = @steps.map(&:weight_total)

        total.map.with_index {|x,i|
          total[0..i].inject(:+)
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
    end
  end
end
