module Toji
  module Ingredient
    module Rice
      class Expected
        include Base
        include ExpectedSteamable

        def initialize(raw, rice_rate: Recipe::RiceRate::Cooked::DEFAULT)
          @raw = raw.to_f

          @rice_rate = rice_rate
          @soaked_rate = rice_rate.soaked_rate
          @before_steaming_rate = rice_rate.before_steaming_rate
          @steamed_rate = rice_rate.steamed_rate
          @cooled_rate = rice_rate.cooled_rate
        end

        def +(other)
          if Base===other
            Actual.new(raw + other.raw, soaked + other.soaked, steaming_water + other.steaming_water, steamed + other.steamed, cooled + other.cooled)
          else
            x, y = other.coerce(self)
            x + y
          end
        end

        def *(other)
          if Integer===other || Float===other
            self.class.new(@raw * other, rice_rate: @rice_rate)
          else
            x, y = other.coerce(self)
            x * y
          end
        end

        def self.create(x)
          if self===x
            x
          else
            new(x)
          end
        end
      end
    end
  end
end
