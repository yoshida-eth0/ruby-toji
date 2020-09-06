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

      def event_groups
        @rice_events.group_by {|e|
          e.group_key
        }.values
      end

      def text
        event_groups.map {|es|
          name = es.first.product.name
          weight = "%.17g" % es.map(&:weight).sum
          "#{name}: #{weight}"
        }.join("<br>")
      end

      def column_events
        event_groups.map {|es|
          {
            product: es.first.product,
            weight: es.map(&:weight).sum,
          }
        }
      end
    end
  end
end
