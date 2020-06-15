module Toji
  module Ingredient
    module Kake
      module Base
        include Rice::Base

        def +(other)
          if Base===other
            Actual.new(raw + other.raw, soaked + other.soaked, steaming_water + other.steaming_water, steamed + other.steamed, cooled + other.cooled)
          else
            x, y = other.coerce(self)
            x + y
          end
        end
      end
    end
  end
end
