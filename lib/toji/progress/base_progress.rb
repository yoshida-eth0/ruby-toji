module Toji
  module Progress
    module BaseProgress
      include Progress

      def base_time
        states&.first&.time&.to_time
      end
    
      def day_offset
        t = base_time
        if t
          offset = (t - Time.mktime(t.year, t.month, t.day)).to_i
          (DAY - date_line + offset) % DAY
        end
      end

      def days
        ((states&.last&.elapsed_time_with_offset&.to_f + 1) / DAY).ceil
      end

      def day_labels
        days.times.map(&:succ).map(&:to_s)
      end

      def all_keys
        BaseState::KEYS
      end

      def has_keys
        all_keys.select {|k|
          states.find {|s| s.send(k).present?}
        }
      end
    end
  end
end
