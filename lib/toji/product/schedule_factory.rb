module Toji
  module Product
    module ScheduleFactory

      def create_koji_schedule(date:, index:, step_indexes:, weight:)
        raise Error, "implement required: create_koji_schedule"
      end

      def create_kake_schedule(date:, index:, step_indexes:, weight:)
        raise Error, "implement required: create_kake_schedule"
      end

      def create_action_schedule(date:, type:, index:)
        raise Error, "implement required: create_action_schedule"
      end

      def koji_schedules
        koji_dates.map.with_index {|date,i|
          {
            index: i,
            date: date,
            koji: recipe.steps[i].koji,
          }
        }.select {|schedule|
          0<schedule[:koji]&.weight.to_f
        }.group_by{|schedule|
          schedule[:date]
        }.map {|date,schedules|
          create_koji_schedule(
            date: date,
            index: koji_dates.find_index(date),
            step_indexes: schedules.map{|schedule| schedule[:index]},
            weight: schedules.map{|schedule| schedule[:koji].weight}.sum,
          )
        }
      end

      def kake_schedules
        kake_dates.map.with_index {|date,i|
          {
            index: i,
            date: date,
            kake: recipe.steps[i].kake,
          }
        }.select {|schedule|
          0<schedule[:kake]&.weight.to_f
        }.group_by{|schedule|
          schedule[:date]
        }.map {|date,schedules|
          create_kake_schedule(
            date: date,
            index: kake_dates.find_index(date),
            step_indexes: schedules.map{|schedule| schedule[:index]},
            weight: schedules.map{|schedule| schedule[:kake].weight}.sum,
          )
        }
      end

      def action_schedules
        action_dates.map.with_index {|date,i|
          create_action_schedule(
            date: date,
            type: recipe.actions[i].type,
            index: i,
          )
        }
      end
    end
  end
end
