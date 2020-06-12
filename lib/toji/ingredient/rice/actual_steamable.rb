module Toji
  module Ingredient
    module Rice
      module ActualSteamable
        def soaked_rate
          soaking_water / raw
        end

        def soaking_water
          soaked - raw
        end

        def before_steaming_rate
          # TODO
        end

        def steamed_rate
          (steamed - raw) / raw 
        end

        def cooled_rate
          (cooled - raw) / raw
        end
      end
    end
  end
end
