module Toji
  class Calendar
    class DateColumn
      attr_reader :rice_events

      def initialize
        @rice_events = []
      end

      def <<(event)
        @rice_events << event
      end
      alias_method :add, :<<

      def text
        @rice_events.map {|ev|
          name = ev.product.name
          raw = "%.17g" % ev.raw
          "#{name}: #{raw}"
        }.join("<br>")
      end
    end
  end
end
