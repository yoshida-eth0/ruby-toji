module Toji
  module Processing
    module KojiProcessing
      include RiceProcessing

      # 出麹実績値
      attr_reader :dekojis

      # 出麹総重量
      def dekoji_total
        (dekojis || []).map(&:weight).sum
      end

      # 出麹歩合
      def dekoji_ratio
        (dekoji_total.to_f - weight_total.to_f) / weight_total.to_f
      end
    end
  end
end
