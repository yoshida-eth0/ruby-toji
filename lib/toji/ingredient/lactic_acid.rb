module Toji
  module Ingredient
    module LacticAcid
      include Base

      # 乳酸
      # @dynamic weight

      def group_key
        [].join(":")
      end
    end
  end
end
