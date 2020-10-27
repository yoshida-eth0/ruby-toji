module Toji
  module Ingredient
    module Alcohol
      include Base

      # 醸造用アルコール
      attr_accessor :weight

      def group_key
        ""
      end
    end
  end
end
