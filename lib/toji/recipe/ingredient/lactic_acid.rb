module Toji
  module Recipe
    module Ingredient
      class LacticAcid

        def initialize(total, rate: Recipe::LacticAcidRate::SIMPLE_SOKUJO)
          @total = total
          @rate = rate
        end

        def moto
          @total * @rate.moto_rate
        end

        def soe
          @total * @rate.soe_rate
        end
      end
    end
  end
end
