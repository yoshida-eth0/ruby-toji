module Toji
  module Ingredient
    module LacticAcid
      include Base

      # 乳酸
      # @dynamic weight

      def ingredient_key
        [].join(":")
      end
    end
  end
end
