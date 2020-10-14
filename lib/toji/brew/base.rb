module Toji
  module Brew
    module Progress
      attr_reader :states
      attr_reader :day_offset

      attr_reader :base_time
      attr_reader :days
      attr_reader :day_labels

      attr_reader :all_keys
    end

    module BaseProgress
      attr_accessor :states
      attr_accessor :day_offset
      attr_accessor :base_time

      def base_time
        states&.first&.time
      end

      def days
        ((states&.last&.elapsed_time_with_offset&.to_f + 1) / DAY).ceil
      end

      def day_labels
        days.times.map(&:succ).map(&:to_s)
      end

      def all_keys
        BaseState::REQUIRED_KEYS
      end

      def has_keys
        all_keys.select {|k|
          states.find {|s| s.send(k).present?}
        }
      end
    end
  end
end
