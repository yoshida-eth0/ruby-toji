require 'toji/schedule/base'

module Toji
  module Schedule
    module RiceSchedule
      include Base

      attr_reader :rice_type
      attr_reader :index
      attr_reader :step_indexes

      attr_reader :weight
      attr_reader :soaked
      attr_reader :steamed
      attr_reader :cooled

      def type
        :rice
      end

      def soaking_ratio
        (soaked.to_f - weight.to_f) / weight.to_f
      end

      def steaming_ratio
        (steamed.to_f - weight.to_f) / weight.to_f
      end

      def cooling_ratio
        (cooled.to_f - weight.to_f) / weight.to_f
      end
    end
  end
end
