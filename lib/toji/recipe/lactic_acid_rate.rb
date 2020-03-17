module Toji
  module Recipe
    class LacticAcidRate

      # 酒母の汲水1Lに対して必要な乳酸の量
      attr_reader :moto_rate
      attr_reader :soe_rate

      def initialize(moto_rate, soe_rate)
        @moto_rate = moto_rate
        @soe_rate = soe_rate
      end

      # 乳酸は汲水100L当たり比重1.21の乳酸(90%乳酸と称される)を650〜720ml添加する。
      # ここでは間をとって685mlとする
      #
      # 出典: 酒造教本 P38
      SOKUJO = new(6.85/1000.0, 0.0)
      SIMPLE_SOKUJO = new(0.006, 0.002)
      KIMOTO = new(0.0, 0.0)
    end
  end
end
