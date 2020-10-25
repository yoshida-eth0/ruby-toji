require 'toji/schedule/rice_schedule'

module Toji
  module Schedule
    module KakeSchedule
      include RiceSchedule

      def rice_type
        :kake
      end
    end
  end
end
