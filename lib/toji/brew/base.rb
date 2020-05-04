module Toji
  module Brew
    class Base
      include Enumerable
      extend StateAccessor

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

      attr_reader :day_offset
      attr_reader :min_time

      def initialize(records, date_line)
        @date_line = date_line
        self.records = records
      end

      def records=(records)
        records = records.map{|r| StateRecord.create(r)}
        min_time = records.map(&:time).compact.sort.first
        @states = records.map{|r| State.new(r.elapsed_time, r, self)}

        # time
        if min_time
          @states.each {|s|
            if s.record.time
              s.elapsed_time = (s.record.time - min_time).to_i
              s.time = s.record.time
            else
              #s.elapsed_time = s.record.elapsed_time
              s.time = min_time + s.record.elapsed_time
            end
          }
        end
        @min_time = @states.first&.time

        @states = @states.sort{|a,b| a.elapsed_time<=>b.elapsed_time}

        # day_offset
        t = @states.first&.time
        @day_offset = 0
        if t
          @day_offset = t - Time.mktime(t.year, t.month, t.day)
        end
        @day_offset = (((24 - @date_line) * HOUR) + @day_offset) % DAY

        # mark hash
        @hash = {}
        @states.select{|s| s.record.mark}.each {|s|
          @hash[s.record.mark] = s
        }
      end

      def days
        ((@states.last.elapsed_time_with_offset.to_f + 1) / DAY).ceil
      end

      def day_labels
        days.times.map(&:succ)
      end

      def moromi_tome_day
        nil
      end

      def [](mark)
        @hash[mark]
      end

      def states
        @states.clone.freeze
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
        date_line = hash[:date_line] || 0
        records = hash[:records] || []

        builder.add(records).date_line(date_line).build
      end

      def self.load_yaml_file(fname)
        hash = YAML.load_file(fname)
        load_hash(hash)
      end
    end
  end
end
