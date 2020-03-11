module Toji
  module Recipe
    class LacticAcidRate
      attr_reader :moto_rate
      attr_reader :soe_rate

      def initialize(moto_rate, soe_rate)
        @moto_rate = moto_rate
        @soe_rate = soe_rate
      end

      SOKUJO = new(0.007, 0.0)
      SIMPLE_SOKUJO = new(0.006, 0.002)
      KIMOTO = new(0.0, 0.0)
    end
  end
end
