module Toji
  module Ingredient
    module Koji
      include Rice

      # 種麹 (has_many: Toji::Ingredient::Tanekoji)
      # @dynamic tanekojis

      # 出麹歩合
      #
      # 出麹歩合17〜19%のものが麹菌の繁殖のほどよい麹である
      #
      # 出典: 酒造教本 P67
      # @dynamic dekoji_ratio

      def dekoji
        weight + weight * dekoji_ratio
      end

      # Scheduleへのグループ識別子
      def ingredient_key
        keys1 = [brand, polishing_ratio, made_in, year, soaking_ratio, steaming_ratio, cooling_ratio, dekoji_ratio]
        keys2 = tanekojis&.map(&:ingredient_key)&.sort || []
        (keys1 + keys2).join(":")
      end

      def default_process_group
        ""
      end
    end
  end
end
