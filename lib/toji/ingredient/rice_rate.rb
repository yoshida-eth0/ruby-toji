module Toji
  module Ingredient
    class RiceRate
      # 浸漬米吸水率
      attr_reader :soaked_rate

      # 蒸米吸水率
      attr_reader :steamed_rate

      # 放冷後蒸米吸水率
      attr_reader :cooled_rate

      def initialize(soaked_rate, steamed_rate, cooled_rate)
        @soaked_rate = soaked_rate
        @steamed_rate = steamed_rate
        @cooled_rate = cooled_rate
      end


      DEFAULT = new(0.33, 0.41, 0.33)
    end
  end
end
