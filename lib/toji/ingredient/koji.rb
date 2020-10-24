module Toji
  module Ingredient
    module Koji
      include Rice

      # 種麹(has_many)
      attr_accessor :tanekojis

      # 出麹歩合
      #
      # 出麹歩合17〜19%のものが麹菌の繁殖のほどよい麹である
      #
      # 出典: 酒造教本 P67
      attr_accessor :dekoji_rate

      def dekoji
        raw + raw * dekoji_rate
      end
    end
  end
end
