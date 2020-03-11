module Toji
  module Product
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
        :warming,
        :note,
      ].freeze

      RO_KEY = [
        :display_time,
        :warmings,
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

      attr_accessor :warming
      attr_accessor :note

      def temps=(val)
        @temps = [val].flatten.select{|t| t}
      end

      def warmings
        result = []
        if @warming & WARM_DAKI
          result << :daki
        end
        if @warming & WARM_ANKA
          result << :anka
        end
        if @warming & WARM_MAT
          result << :mat
        end
        result
      end

      def to_h
        h = {}
        KEYS.each {|k|
          h[k] = send(k)
        }
        RO_KEYS.each {|k|
          h[k] = send(k)
        }
        h
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
