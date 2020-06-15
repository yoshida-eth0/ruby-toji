module Toji
  module Brew
    class Base
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

      attr_accessor :states
      attr_accessor :day_offset
      attr_accessor :min_time

      def initialize
        @states = []
        @day_offset = 0
        @min_time = 0
      end

      def days
        ((@states.last.elapsed_time_with_offset.to_f + 1) / DAY).ceil
      end

      def day_labels
        days.times.map(&:succ).map(&:to_s)
      end

      def moromi_tome_day
        nil
      end

      def each(&block)
        @states.each(&block)
      end

      def has_keys
        result = REQUIRED_KEYS.clone

        result += OPTIONAL_KEYS.select {|k|
          @states.find {|s| s.send(k).present?}
        }
      end

      def to_h
        {
          states: map(&:to_h),
          has_keys: has_keys,
          day_offset: day_offset,
          days: days,
          day_labels: day_labels,
        }
      end

      def self.create(records, date_line: 0)
        if Base===records
          records
        else
          builder.add(records).date_line(date_line).build
        end
      end

      def self.builder
        Builder.new(self)
      end

      def self.load_hash(hash)
        hash = hash.deep_symbolize_keys

        builder
          .add(hash[:records] || [])
          .date_line(hash[:date_line] || 0)
          .prefix_day_labels(hash[:prefix_day_labels])
          .build
      end

      def self.load_yaml_file(fname)
        hash = YAML.load_file(fname)
        load_hash(hash)
      end
    end
  end
end
