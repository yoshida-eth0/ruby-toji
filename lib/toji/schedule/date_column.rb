module Toji
  module Schedule
    class DateColumn
      attr_reader :events

      def initialize
        @events = []
      end

      def <<(event)
        @events << event
      end
      alias_method :add, :<<

      def event_groups
        @events.group_by {|e|
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

      def to_h_a
        event_groups.map {|es|
          {
            product_id: es.first.product.id,
            product_name: es.first.product.name,
            weight: es.map(&:weight).sum,
          }
        }
      end
    end
  end
end
