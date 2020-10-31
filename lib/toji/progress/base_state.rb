module Toji
  module Progress
    module BaseState
      REQUIRED_KEYS = [
        :time,
        :elapsed_time,
        :day,
        :day_label,
        :display_time,
        :mark,
      ].freeze

      attr_accessor :progress

      attr_accessor :time
      attr_accessor :mark

      def elapsed_time
        time - progress.base_time
      end

      def elapsed_time_with_offset
        elapsed_time + progress.day_offset
      end

      def day
        ((elapsed_time_with_offset.to_f + 1) / DAY).ceil
      end

      def day_label
        progress.day_labels[day - 1]
      end

      def display_time(format="%m/%d %H:%M")
        time.strftime(format)
      end
    end
  end
end
