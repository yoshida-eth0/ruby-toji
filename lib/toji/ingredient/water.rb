module Toji
  module Ingredient
    module Water
      include Base

      # 汲水
      attr_accessor :weight

      # 硬度
      attr_accessor :hardness

      def group_key
        [hardness].join(":")
      end
    end
  end
end
