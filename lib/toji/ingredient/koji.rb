module Toji
  module Ingredient
    module Koji
      include Rice

      # 種麹
      #
      # 総破精麹を造るには、種麹の量を麹米100kgあたり種麹100gとする
      # 突き破精麹を造るには、種麹の量を麹米100kgあたり種麹80gとする
      #
      # 出典: 酒造教本 P66
      attr_accessor :tanekoji_rate

      def tanekoji
        raw * tanekoji_rate
      end

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
