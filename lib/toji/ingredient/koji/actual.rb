module Toji
  module Ingredient
    module Koji
      class Actual
        include Base
        include Rice::ActualSteamable
        include ActualFermentable

        def initialize(raw, soaked, steamed, cooled, tanekoji, dekoji)
          @raw = raw.to_f
          @soaked = soaked.to_f
          @steamed = steamed.to_f
          @cooled = cooled.to_f
          @tanekoji = tanekoji.to_f
          @dekoji = dekoji.to_f
        end

        def *(other)
          if Integer===other || Float===other
            Actual.new(raw * other, soaked * other, steamed * other, cooled * other, tanekoji * other, dekoji * other)
          else
            x, y = other.coerce(self)
            x * y
          end
        end
      end
    end
  end
end
