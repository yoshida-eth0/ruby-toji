module Toji
  module Ingredient
    module Yeast
      # 酵母
      attr_accessor :weight

      # 単位 (ex: ampoule, gram, ml)
      attr_accessor :unit

      # 酵母名、協会酵母番号
      attr_accessor :brand
    end
  end
end
