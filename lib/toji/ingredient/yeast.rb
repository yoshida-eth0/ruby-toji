module Toji
  module Ingredient
    module Yeast
      include Base

      # 酵母
      # @dynamic weight
      # @dynamic weight=

      # 単位 (ex: ampoule, gram, ml)
      # @dynamic unit

      # 酵母名、協会酵母番号
      # @dynamic brand

      def ingredient_key
        [brand, unit].join(":")
      end
    end
  end
end
