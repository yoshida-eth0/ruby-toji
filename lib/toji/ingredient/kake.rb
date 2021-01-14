module Toji
  module Ingredient
    module Kake
      include Rice

      def group_key
        [brand, polishing_ratio, made_in, year, soaking_ratio, steaming_ratio, cooling_ratio, process_group].join(":")
      end
    end
  end
end
