module Toji
  module Ingredient
    module Kake
      class Actual
        include Base
        include Rice::ActualSteamable

        def initialize(raw, soaked, steaming_water, steamed, cooled)
          @raw = raw
          @soaked = soaked
          @steaming_water = steaming_water
          @steamed = steamed
          @cooled = cooled
        end

        def *(other)
          if Integer===other || Float===other
            Actual.new(raw * other, soaked * other, steaming_water * other, steamed * other, cooled * other)
          else
            x, y = other.coerce(self)
            x * y
          end
        end
      end
    end
  end
end
