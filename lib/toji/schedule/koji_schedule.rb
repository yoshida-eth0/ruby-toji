module Toji
  module Schedule
    module KojiSchedule
      include RiceSchedule

      def rice_type
        :koji
      end
    end
  end
end
