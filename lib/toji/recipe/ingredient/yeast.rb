module Toji
  module Recipe
    module Ingredient
      class Yeast

        def initialize(total, rate: Recipe::YeastRate::RED_STAR)
          @total = total
          @rate = rate
        end

        def yeast
          @total * @rate.yeast_rate / 1000.0
        end

        def water
          yeast * @rate.water_rate
        end
      end
    end
  end
end
