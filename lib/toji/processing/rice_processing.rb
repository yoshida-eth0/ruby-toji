module Toji
  module Processing
    module RiceProcessing
      include Base

      # 目標値(Toji::Ingredient::Rice)
      attr_reader :expect

      # 室内温度
      attr_reader :room_temp

      # 外気温
      attr_reader :outside_temp

      # 白米の含水率
      attr_reader :rice_water_content

      # 洗米に用いる水の温度
      attr_reader :washing_water_temp

      # 浸漬に用いる水の温度
      attr_reader :soaking_water_temp

      # 浸漬実績値
      attr_reader :soaked_rices

      # 蒸米実績値
      attr_reader :steamed_rices

      # 放冷実績値
      attr_reader :cooled_rices

      # 白米総重量
      def weight_total
        (soaked_rices || []).map(&:weight).sum
      end

      # 浸漬米重量
      def soaked_total
        (soaked_rices || []).map(&:soaked).sum
      end

      # 浸漬米吸水率
      def soaking_ratio
        (soaked_total.to_f - weight_total.to_f) / weight_total.to_f
      end

      # 浸漬米吸水率の標準偏差
      def soaking_ratio_sd
        mean = soaking_ratio
        samples = (soaked_rices || []).map(&:soaking_ratio)
        length = samples.length.to_f
        Math.sqrt(samples.map{|sample| (sample - mean) ** 2}.sum / length)
      end

      # 蒸米重量
      def steamed_total
        (steamed_rices || []).map(&:weight).sum
      end

      # 蒸米歩合
      def steaming_ratio
        (steamed_total.to_f - weight_total.to_f) / weight_total.to_f
      end

      # 放冷後蒸米重量
      def cooled_total
        (cooled_rices || []).map(&:weight).sum
      end

      # 放冷後蒸米歩合
      def cooling_ratio
        (cooled_total.to_f - weight_total.to_f) / weight_total.to_f
      end
    end
  end
end
