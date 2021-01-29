module Toji
  class Calendar
    class DateColumn
      attr_reader :rice_schedules

      def initialize
        @rice_schedules = []
      end

      def <<(schedule)
        @rice_schedules << schedule
      end
      alias_method :add, :<<

      def text
        @rice_schedules.map {|schedule|
          serial_num = schedule.product.serial_num
          weight = "%.17g" % schedule.expect.weight
          "#{serial_num}: #{weight}"
        }.join("<br>")
      end
    end
  end
end
