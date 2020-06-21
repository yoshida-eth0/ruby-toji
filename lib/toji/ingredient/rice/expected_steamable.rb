module Toji
  module Ingredient
    module Rice
      module ExpectedSteamable
        def soaking_water
          raw * soaked_rate
        end

        def soaked
          raw + raw * soaked_rate
        end

        def steaming_water
          raw * steamed_rate
        end

        def steamed
          raw + raw * steamed_rate
        end

        def cooled
          raw + raw * cooled_rate
        end
      end
    end
  end
end
