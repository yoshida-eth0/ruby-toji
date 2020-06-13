module Toji
  module Brew
    class StateRecord
      include Statable

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

      def self.create(r)
        if Statable===r
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
