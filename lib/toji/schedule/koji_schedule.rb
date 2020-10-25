require 'toji/schedule/rice_schedule'

module Toji
  module Schedule
    module KojiSchedule
      include RiceSchedule

      attr_reader :dekoji

      def rice_type
        :koji
      end

      def dekoji_ratio
        (dekoji.to_f - weight.to_f) / weight.to_f
      end
    end
  end
end
