module Toji
  module Ingredient
    module Koji
      module ActualFermentable
        def tanekoji_rate
          tanekoji / raw
        end

        def dekoji_rate
          (dekoji - raw) / raw
        end
      end
    end
  end
end
