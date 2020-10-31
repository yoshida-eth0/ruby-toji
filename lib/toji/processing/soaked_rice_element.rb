module Toji
  module Processing
    module SoakedRiceElement
      # 白米重量
      attr_reader :weight

      # 浸漬時間
      attr_reader :soaking_time

      # 浸漬米重量
      attr_reader :soaked

      def soaking_ratio
        (soaked.to_f - weight.to_f) / weight.to_f
      end
    end
  end
end
