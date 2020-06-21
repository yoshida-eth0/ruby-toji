module Toji
  module Brew
    module Base
      include Enumerable

      REQUIRED_KEYS = [
        :time,
        :elapsed_time,
        :day,
        :day_label,
        :display_time,
      ].freeze

      OPTIONAL_KEYS = [
        :moromi_day,
        :mark,
        :temps,
        :preset_temp,
        :room_temp,
        :room_psychrometry,
        :baume,
        :nihonshudo,
        :display_baume,
        :acid,
        :amino_acid,
        :alcohol,
        :bmd,
        :warmings,
        :note,
      ].freeze

      attr_accessor :wrapped_states
      attr_accessor :day_offset
      attr_accessor :base_time

      def days
        ((wrapped_states.last.elapsed_time_with_offset.to_f + 1) / DAY).ceil
      end

      def day_labels
        days.times.map(&:succ).map(&:to_s)
      end

      def moromi_tome_day
        nil
      end

      def each(&block)
        wrapped_states.each(&block)
      end

      def has_keys
        result = REQUIRED_KEYS.dup

        result += OPTIONAL_KEYS.select {|k|
          wrapped_states.find {|s| s.send(k).present?}
        }
      end
    end
  end
end
