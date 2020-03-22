module Toji
  module Recipe
    module Ingredient
      module Rice
        module Base
          # 白米
          attr_reader :raw

          # 浸漬米吸水率
          #
          # 標準的な白米吸水率は掛米で30〜35%、麹米で33%前後で許容範囲はかなり狭い
          #
          # 出典: 酒造教本 P38
          attr_reader :soaked_rate
          attr_reader :soaking_water
          attr_reader :soaked

          # 蒸米吸水率
          #
          # 蒸しにより通常甑置き前の浸漬白米の重量よりさらに12〜13%吸水する
          # 蒸しにより吸水の増加が13%を超える場合は、蒸米の表面が柔らかくべとつく蒸米になりやすい
          # 蒸米吸水率は麹米及び酒母米で41〜43%、掛米は39〜40%で、吟醸造りの場合は数%低い
          #
          # 出典: 酒造教本 P48
          attr_reader :steamed_rate
          attr_reader :steaming_water
          attr_reader :steamed

          # 放冷
          #
          # 冷却法で若干異なるが蒸米の冷却により掛米で白米重量の10%、麹米で8%程度の水が失われる
          # 出典: 酒造教本 P49
          #
          # 麹を造るのに適した蒸米は、引込時の吸水率が33%を理想とし、許容幅はプラスマイナス1%である
          # 出典: 酒造教本 P59
          attr_reader :cooled_rate
          attr_reader :cooled

          def +(other)
            if Base===other
              Actual.new(raw + other.raw, soaked + other.soaked, steaming_water + other.steaming_water, steamed + other.steamed, cooled + other.cooled)
            else
              x, y = other.coerce(self)
              x + y
            end
          end
        end
      end
    end
  end
end
