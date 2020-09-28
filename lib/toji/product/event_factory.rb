module Toji
  module Product
    module EventFactory

      def create_koji_event(date:, index:, step_indexes:, raw:)
        raise Error, "implement required: create_koji_event"
      end

      def create_kake_event(date:, index:, step_indexes:, raw:)
        raise Error, "implement required: create_kake_event"
      end

      def create_action_event(date:, type:, index:)
        raise Error, "implement required: create_action_event"
      end

      def koji_events
        koji_dates.map.with_index {|date,i|
          {
            index: i,
            date: date,
            weight: recipe.steps[i].koji,
          }
        }.select {|event|
          0<event[:weight]
        }.group_by{|event|
          event[:date]
        }.map {|date,events|
          create_koji_event(
            date: date,
            index: koji_dates.find_index(date),
            step_indexes: events.map{|ev| ev[:index]},
            raw: events.map{|ev| ev[:weight]}.sum,
          )
        }
      end

      def kake_events
        kake_dates.map.with_index {|date,i|
          {
            index: i,
            date: date,
            weight: recipe.steps[i].kake,
          }
        }.select {|event|
          0<event[:weight]
        }.group_by{|event|
          event[:date]
        }.map {|date,events|
          create_kake_event(
            date: date,
            index: kake_dates.find_index(date),
            step_indexes: events.map{|ev| ev[:index]},
            raw: events.map{|ev| ev[:weight]}.sum,
          )
        }
      end

      def action_events
        action_dates.map.with_index {|date,i|
          create_action_event(
            date: date,
            type: recipe.actions[i].type,
            index: i,
          )
        }
      end
    end
  end
end
