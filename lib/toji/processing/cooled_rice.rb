module Toji
  module Processing
    module CooledRice
      # 親 (belongs_to: Toji::Processing::RiceProcessing)
      attr_reader :processing

      # 要素 (has_many: Toji::Processing::CooledRiceElement)
      attr_reader :elements

      # 放冷後蒸米総重量
      def weight
        (elements || []).map(&:weight).sum
      end

      # 放冷後蒸米歩合
      def cooling_ratio
        raw_weight = processing.soaked_rice.weight.to_f
        (weight.to_f - raw_weight) / raw_weight
      end
    end
  end
end
