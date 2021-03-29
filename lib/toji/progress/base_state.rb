module Toji
  module Progress
    module BaseState
      include State

      KEYS = [
        :time,
        :elapsed_time,
        :day,
        :day_label,
        :display_time,
        :mark,

        :temps,
        :preset_temp,
        :room_dry_temp,
        :room_wet_temp,
        :room_psychrometry,
        :room_relative_humidity_from_dry_and_wet,
        :room_relative_humidity,

        :note,
      ].freeze

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

      # @dynamic temps
      # @dynamic preset_temp
      # @dynamic room_dry_temp
      # @dynamic room_wet_temp
      # @dynamic room_relative_humidity
      # @dynamic note

      # 乾湿差
      def room_psychrometry
        if room_dry_temp && room_wet_temp
          room_dry_temp.to_f - room_wet_temp.to_f
        end
      end

      # 相対湿度
      def room_relative_humidity_from_dry_and_wet(swvp: Swvp.default, pressure: 1013, k: 0.000662)
        if room_dry_temp && room_wet_temp
          psy2rh = PsychrometryToRelativeHumidity.new(swvp: swvp, pressure: pressure, k: k)
          psy2rh.convert(room_wet_temp.to_f, room_dry_temp.to_f)
        end
      end
    end
  end
end
