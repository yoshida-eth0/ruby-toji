module Toji
  module Ingredient
    module Alcohol
      include Base

      # 醸造用アルコール
      # @dynamic weight

      def ingredient_key
        [].join(":")
      end
    end
  end
end
