module Toji
  module Processing
    module SteamedRice
      # 親 (belongs_to: Toji::Processing::RiceProcessing)
      # @dynamic processing

      # 要素 (has_many: Toji::Processing::SteamedRiceElement)
      # @dynamic elements

      # 蒸米総重量
      def weight
        (elements || []).map(&:weight).sum
      end

      # 蒸米歩合
      def steaming_ratio
        raw_weight = processing.soaked_rice.weight.to_f
        (weight.to_f - raw_weight) / raw_weight
      end
    end
  end
end
