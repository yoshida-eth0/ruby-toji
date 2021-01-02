module Toji
  module Schedule
    module RiceSchedule
      include Base

      # @dynamic rice_type
      # @dynamic step_weights

      # @dynamic expect

      def type
        :rice
      end
    end
  end
end
