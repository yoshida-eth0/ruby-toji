module Toji
  module Ingredient
    module Kake
      class Actual
        include Base
        include Rice::ActualSteamable

        def initialize(raw, soaked, steamed, cooled)
          @raw = raw.to_f
          @soaked = soaked.to_f
          @steamed = steamed.to_f
          @cooled = cooled.to_f
        end

        def *(other)
          if Integer===other || Float===other
            Actual.new(raw * other, soaked * other, steamed * other, cooled * other)
          else
            x, y = other.coerce(self)
            x * y
          end
        end
      end
    end
  end
end
