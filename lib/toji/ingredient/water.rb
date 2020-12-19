module Toji
  module Ingredient
    module Water
      include Base

      # 汲水
      # @dynamic weight

      # 硬度
      # @dynamic calcium_hardness
      # @dynamic magnesium_hardness

      def group_key
        [calcium_hardness, magnesium_hardness].join(":")
      end
    end
  end
end
