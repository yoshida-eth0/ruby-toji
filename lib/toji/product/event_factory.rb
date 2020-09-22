module Toji
  module Product
    module EventFactory

      def create_rice_event(product:, date:, rice_type:, index:, group_index:, weight:)
        raise Error, "implement required: create_rice_event"
      end

      def create_rice_event_group(date:, rice_type:, breakdown:)
        raise Error, "implement required: create_rice_event_group"
      end

      def create_action_event(product:, date:, type:, index:)
        raise Error, "implement required: create_action_event"
      end

      def koji_events
        koji_dates.map.with_index {|date,i|
          create_rice_event(
            product: self,
            rice_type: :koji,
            index: i,
            group_index: koji_dates.find_index(date),
            date: date,
            weight: recipe.steps[i].koji,
          )
        }
      end

      def kake_events
        kake_dates.map.with_index {|date,i|
          create_rice_event(
            product: self,
            rice_type: :kake,
            index: i,
            group_index: kake_dates.find_index(date),
            date: date,
            weight: recipe.steps[i].kake,
          )
        }
      end

      def koji_event_groups
        koji_events.select{|event|
          0<event.weight
        }.group_by{|event|
          event.group_key
        }.map {|group_key,events|
          event = events.first
          create_rice_event_group(
            date: event.date,
            rice_type: event.rice_type,
            breakdown: events,
          )
        }
      end

      def kake_event_groups
        kake_events.select{|event|
          0<event.weight
        }.group_by{|event|
          event.group_key
        }.map {|group_key,events|
          event = events.first
          create_rice_event_group(
            date: event.date,
            rice_type: event.rice_type,
            breakdown: events,
          )
        }
      end

      def action_events
        action_dates.map.with_index {|date,i|
          action = recipe.actions[i]
          create_action_event(
            product: self,
            date: date,
            type: recipe.actions[i].type,
            index: i,
          )
        }
      end
    end
  end
end
