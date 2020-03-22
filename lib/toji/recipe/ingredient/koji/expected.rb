module Toji
  module Recipe
    module Ingredient
      module Koji
        class Expected
          include Base
          include Rice::ExpectedSteamable
          include ExpectedFermentable

          def initialize(raw, rice_rate: Recipe::RiceRate::Cooked::DEFAULT, koji_rate: Recipe::KojiRate::DEFAULT)
            @raw = raw.to_f

            @rice_rate = rice_rate
            @soaked_rate = rice_rate.soaked_rate
            @before_steaming_rate = rice_rate.before_steaming_rate
            @steamed_rate = rice_rate.steamed_rate
            @cooled_rate = rice_rate.cooled_rate

            @koji_rate = koji_rate
            @tanekoji_rate = koji_rate.tanekoji_rate
            @dekoji_rate = koji_rate.dekoji_rate
          end

          def round(ndigit=0, half: :up)
            self.class.new(@raw.round(ndigit, half: half), rice_rate: @rice_rate, koji_rate: @koji_rate)
          end

          def self.create(x)
            if self===x
              x
            else
              new(x)
            end
          end

          def *(other)
            if Integer===other || Float===other
              Expected.new(@raw * other, rice_rate: @rice_rate, koji_rate: @koji_rate)
            else
              x, y = other.coerce(self)
              x * y
            end
          end
        end
      end
    end
  end
end
