require 'toji/event/base'

module Toji
  module Event
    module RiceEvent
      include Base

      attr_reader :rice_type
      attr_reader :group_index
      attr_reader :indexes

      attr_reader :raw
      attr_reader :soaked
      attr_reader :steamed
      attr_reader :cooled

      def type
        :rice
      end

      def soaked_rate
        (soaked.to_f - raw.to_f) / raw.to_f
      end

      def steamed_rate
        (steamed.to_f - raw.to_f) / raw.to_f
      end

      def cooled_rate
        (cooled.to_f - raw.to_f) / raw.to_f
      end
    end
  end
end
