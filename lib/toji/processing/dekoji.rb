module Toji
  module Processing
    module Dekoji
      # 親 (belongs_to: Toji::Processing::RiceProcessing)
      attr_reader :processing

      # 要素 (has_many: Toji::Processing::DekojiElement)
      attr_reader :elements

      # 出麹総重量
      def weight
        (elements || []).map(&:weight).sum
      end

      # 出麹歩合
      def dekoji_ratio
        raw_weight = processing.soaked_rice.weight.to_f
        (weight.to_f - raw_weight) / raw_weight
      end
    end
  end
end
