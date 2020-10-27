module Toji
  module Ingredient
    module LacticAcid
      include Base

      # 乳酸
      attr_accessor :weight

      def group_key
        ""
      end
    end
  end
end
