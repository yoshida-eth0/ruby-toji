module Toji
  module Brew
    class StateRecord
      KEYS = [
        :time,
        :elapsed_time,
        :mark,
        :temps,
        :preset_temp,
        :room_temp,
        :room_psychrometry,
        :baume,
        :nihonshudo,
        :acid,
        :amino_acid,
        :alcohol,
        :warmings,
        :note,
      ].freeze

      attr_accessor :time
      attr_accessor :elapsed_time
      attr_accessor :mark
      attr_accessor :temps

      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry

      attr_accessor :baume
      attr_accessor :nihonshudo
      attr_accessor :acid
      attr_accessor :amino_acid
      attr_accessor :alcohol

      attr_accessor :warmings
      attr_accessor :note

      def temps=(val)
        @temps = [val].flatten.compact
      end

      def time=(val)
        @time = val&.to_time
      end

      def warmings=(val)
        @warmings = [val].flatten.compact
      end

      def self.create(r)
        if StateRecord===r
          r
        elsif State==r
          r.record
        elsif Hash===r
          record = new
          KEYS.each {|k|
            record.send("#{k}=", r[k])
          }
          record
        else
          record = new
          KEYS.each {|k|
            record.send("#{k}=", r.send(k))
          }
          record
        end
      end
    end
  end
end
