module Toji
  module Ingredient
    module Yeast
      include Base

      # 酵母
      attr_accessor :weight

      # 単位 (ex: ampoule, gram, ml)
      attr_reader :unit

      # 酵母名、協会酵母番号
      attr_reader :brand

      def group_key
        [brand, unit].join(":")
      end
    end
  end
end
