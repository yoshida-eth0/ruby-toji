module Toji
  module Processing
    module SoakedRiceElement
      # 白米重量
      # @dynamic weight

      # 浸漬時間
      # @dynamic soaking_time

      # 浸漬米重量
      # @dynamic soaked

      def soaking_ratio
        (soaked.to_f - weight.to_f) / weight.to_f
      end
    end
  end
end
