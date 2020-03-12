module Toji
  module Recipe
    module Ingredient
      module Koji
        class Actual
          include Base
          include Rice::ActualSteamable
          include ActualFermentable

          def initialize(raw, soaked, steaming_water, steamed, cooled, tanekoji, dekoji)
            @raw = raw
            @soaked = soaked
            @steaming_water = steaming_water
            @steamed = steamed
            @cooled = cooled
            @tanekoji = tanekoji
            @dekoji = dekoji
          end
        end
      end
    end
  end
end
