module Toji
  module Ingredient
    module Water
      include Base

      # 汲水
      attr_accessor :weight

      # 硬度
      attr_reader :calcium_hardness
      attr_reader :magnesium_hardness

      def group_key
        [calcium_hardness, magnesium_hardness].join(":")
      end
    end
  end
end
