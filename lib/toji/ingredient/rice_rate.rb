module Toji
  module Ingredient
    class RiceRate
      # 浸漬米吸水率
      attr_reader :soaked_rate

      # 蒸し前浸漬米吸水率
      # 炊飯の場合は水を追加
      # 蒸しの場合は一晩経って蒸発した分を削減
      attr_reader :before_steaming_rate

      # 蒸米吸水率
      attr_reader :steamed_rate

      # 放冷後蒸米吸水率
      attr_reader :cooled_rate

      def initialize(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
        @soaked_rate = soaked_rate
        @before_steaming_rate = before_steaming_rate
        @steamed_rate = steamed_rate
        @cooled_rate = cooled_rate
      end

      def before_steaming_rate
        @before_steaming_rate || begin
          @soaked_rate - 0.04
        end
      end


      DEFAULT = new(0.33, nil, 0.41, 0.33)
    end
  end
end
