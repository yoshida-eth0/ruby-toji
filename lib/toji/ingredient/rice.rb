module Toji
  module Ingredient
    module Rice
      # 白米
      attr_accessor :raw

      # 品種、産地、年度
      attr_accessor :brand
      attr_accessor :made_in
      attr_accessor :year

      # 浸漬米吸水率
      #
      # 標準的な白米吸水率は掛米で30〜35%、麹米で33%前後で許容範囲はかなり狭い
      #
      # 出典: 酒造教本 P38
      attr_accessor :soaked_rate

      def soaked
        raw + raw * soaked_rate
      end

      # 蒸米吸水率
      #
      # 蒸しにより通常甑置き前の浸漬白米の重量よりさらに12〜13%吸水する
      # 蒸しにより吸水の増加が13%を超える場合は、蒸米の表面が柔らかくべとつく蒸米になりやすい
      # 蒸米吸水率は麹米及び酒母米で41〜43%、掛米は39〜40%で、吟醸造りの場合は数%低い
      #
      # 出典: 酒造教本 P48
      attr_accessor :steamed_rate

      def steamed
        raw + raw * steamed_rate
      end

      # 放冷
      #
      # 冷却法で若干異なるが蒸米の冷却により掛米で白米重量の10%、麹米で8%程度の水が失われる
      # 出典: 酒造教本 P49
      #
      # 麹を造るのに適した蒸米は、引込時の吸水率が33%を理想とし、許容幅はプラスマイナス1%である
      # 出典: 酒造教本 P59
      attr_accessor :cooled_rate

      def cooled
        raw + raw * cooled_rate
      end
    end
  end
end
