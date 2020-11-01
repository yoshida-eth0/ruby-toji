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
          name = schedule.product.name
          weight = "%.17g" % schedule.expect.weight
          "#{name}: #{weight}"
        }.join("<br>")
      end
    end
  end
end
