module Toji
  module Ingredient
    module Tanekoji
      include Base

      # 麹 (belongs_to: Toji::Ingredient::Koji)
      attr_reader :koji

      # 種麹の種類
      attr_reader :brand

      # 種麹
      #
      # 総破精麹を造るには、種麹の量を麹米100kgあたり種麹100gとする
      # 突き破精麹を造るには、種麹の量を麹米100kgあたり種麹80gとする
      #
      # 出典: 酒造教本 P66
      attr_reader :ratio

      def weight
        koji.weight * ratio
      end

      def group_key
        [brand, ratio].join(":")
      end
    end
  end
end
