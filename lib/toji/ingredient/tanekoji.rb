module Toji
  module Ingredient
    module Tanekoji
      # 麹(belongs_to)
      attr_accessor :koji

      # 種麹の種類
      attr_accessor :brand

      # 種麹
      #
      # 総破精麹を造るには、種麹の量を麹米100kgあたり種麹100gとする
      # 突き破精麹を造るには、種麹の量を麹米100kgあたり種麹80gとする
      #
      # 出典: 酒造教本 P66
      attr_accessor :ratio

      def weight
        koji.weight * ratio
      end
    end
  end
end
