module Toji
  module Schedule
    module RiceSchedule
      include Base

      attr_reader :rice_type
      attr_reader :step_indexes

      attr_reader :expect

      def type
        :rice
      end
    end
  end
end
