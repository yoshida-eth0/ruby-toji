module Toji
  module Processing
    module SoakedRice
      # 室内温度
      # @dynamic room_dry_temp

      # 外気温
      # @dynamic outside_temp

      # 白米の含水率
      # @dynamic rice_water_content

      # 洗米に用いる水の温度
      # @dynamic washing_water_temp

      # 浸漬に用いる水の温度
      # @dynamic soaking_water_temp

      # 親 (belongs_to: Toji::Processing::RiceProcessing)
      # @dynamic processing

      # 要素 (has_many: Toji::Processing::SoakedRiceElement)
      # @dynamic elements

      # 白米総重量
      def weight
        (elements || []).map(&:weight).sum
      end

      # 浸漬米総重量
      def soaked
        (elements || []).map(&:soaked).sum
      end

      # 浸漬米吸水率
      def soaking_ratio
        (soaked.to_f - weight.to_f) / weight.to_f
      end

      # 浸漬米吸水率の標準偏差
      def soaking_ratio_sd
        mean = soaking_ratio
        samples = (elements || []).map(&:soaking_ratio)
        length = samples.length.to_f
        Math.sqrt(samples.map{|sample| (sample - mean) ** 2}.sum / length)
      end
    end
  end
end
