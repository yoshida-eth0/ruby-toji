module Toji
  module Ingredient
    module Kake
      include Rice

      def ingredient_key
        [brand, polishing_ratio, made_in, year, soaking_ratio, steaming_ratio, cooling_ratio].join(":")
      end

      def default_process_group
        self.hash
      end
    end
  end
end
