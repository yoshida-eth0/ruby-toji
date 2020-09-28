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

      def <<(event)
        case event.rice_type
        when :koji
          index = event.group_index
          @kojis[index] ||= DateColumn.new
          @kojis[index] << event
        when :kake
          index = event.group_index
          @kakes[index] ||= DateColumn.new
          @kakes[index] << event
        end
      end
      alias_method :add, :<<
    end
  end
end
