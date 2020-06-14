module Toji
  module Ingredient
    module Koji
      module ExpectedFermentable
        def tanekoji
          raw * tanekoji_rate
        end

        def dekoji
          raw + raw * dekoji_rate
        end
      end
    end
  end
end
