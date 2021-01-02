module Toji
  class Calendar
    class DateRow
      attr_reader :date
      attr_reader :kojis
      attr_reader :kakes

      def initialize(date)
        @date = date
        @kojis = []
        @kakes = []
      end

      def <<(schedule)
        case schedule.rice_type
        when :koji
          index = schedule.step_weights.first[:index]
          @kojis[index] ||= DateColumn.new
          @kojis[index] << schedule
        when :kake
          index = schedule.step_weights.first[:index]
          @kakes[index] ||= DateColumn.new
          @kakes[index] << schedule
        end
      end
      alias_method :add, :<<
    end
  end
end
