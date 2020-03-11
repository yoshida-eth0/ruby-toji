module Toji
  module Ingredient
    class LacticAcid

      def initialize(total, lactic_acid_rate: Recipe::LacticAcidRate::SIMPLE_SOKUJO)
        @total = total
        @lactic_acid_rate = lactic_acid_rate
      end

      def moto
        @total * @lactic_acid_rate.moto_rate
      end

      def soe
        @total * @lactic_acid_rate.soe_rate
      end
    end
  end
end
