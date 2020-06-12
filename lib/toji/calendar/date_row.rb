module Toji
  class Calendar
    class DateRow
      attr_reader :date
      attr_reader :kojis
      attr_reader :rices

      def initialize(date)
        @date = date
        @kojis = []
        @rices = []
      end

      def <<(event)
        case event.type
        when :koji
          index = event.group_index
          @kojis[index] ||= DateColumn.new
          @kojis[index] << event
        when :rice
          index = event.group_index
          @rices[index] ||= DateColumn.new
          @rices[index] << event
        end
      end
      alias_method :add, :<<
    end
  end
end
