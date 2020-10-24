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
          weight = "%.17g" % ev.weight
          "#{name}: #{weight}"
        }.join("<br>")
      end
    end
  end
end
