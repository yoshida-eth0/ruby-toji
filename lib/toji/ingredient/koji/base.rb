module Toji
  module Ingredient
    module Koji
      module Base
        include Rice::Base

        # 種麹
        #
        # 総破精麹を造るには、種麹の量を麹米100kgあたり種麹100gとする
        # 突き破精麹を造るには、種麹の量を麹米100kgあたり種麹80gとする
        #
        # 出典: 酒造教本 P66
        attr_reader :tanekoji_rate
        attr_reader :tanekoji

        # 出麹歩合
        #
        # 出麹歩合17〜19%のものが麹菌の繁殖のほどよい麹である
        #
        # 出典: 酒造教本 P67
        attr_reader :dekoji_rate
        attr_reader :dekoji

        def +(other)
          if Base===other
            Actual.new(raw + other.raw, soaked + other.soaked, steaming_water + other.steaming_water, steamed + other.steamed, cooled + other.cooled, tanekoji + other.tanekoji, dekoji + other.dekoji)
          else
            x, y = other.coerce(self)
            x + y
          end
        end
      end
    end
  end
end
