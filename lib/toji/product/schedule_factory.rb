module Toji
  module Product
    module ScheduleFactory

      # @dynamic recipe
      # @dynamic base_date

      def create_koji_schedule(date:, group_key:, step_weights:, kojis:)
        raise Error, "implement required: create_koji_schedule"
      end

      def create_kake_schedule(date:, group_key:, step_weights:, kakes:)
        raise Error, "implement required: create_kake_schedule"
      end

      def create_action_schedule(date:, action_index:, action:)
        raise Error, "implement required: create_action_schedule"
      end

      def koji_schedules
        recipe.steps.inject([]) {|result, step|
          step.kojis&.each {|koji|
            result << {
              step_weight: {
                index: step.index,
                subindex: step.subindex,
                weight: koji.weight,
              },
              date: base_date.next_day(koji.interval_days),
              koji: koji,
            }
          }
          result
        }.select {|schedule|
          0<schedule[:koji]&.weight.to_f
        }.group_by {|schedule|
          [schedule[:date], schedule[:koji].group_key]
        }.map {|(date, group_key), schedules|
          create_koji_schedule(
            date: date,
            group_key: group_key,
            step_weights: schedules.map {|schedule| schedule[:step_weight]}.sort_by {|x| [x[:index], x[:subindex]]},
            kojis: schedules.map{|schedule| schedule[:koji]},
          )
        }
      end

      def kake_schedules
        recipe.steps.inject([]) {|result, step|
          step.kakes&.each {|kake|
            result << {
              step_weight: {
                index: step.index,
                subindex: step.subindex,
                weight: kake.weight,
              },
              date: base_date.next_day(kake.interval_days),
              kake: kake,
            }
          }
          result
        }.select {|schedule|
          0<schedule[:kake]&.weight.to_f
        }.group_by {|schedule|
          [schedule[:date], schedule[:kake].group_key]
        }.map {|(date, group_key), schedules|
          create_kake_schedule(
            date: date,
            group_key: group_key,
            step_weights: schedules.map {|schedule| schedule[:step_weight]}.sort_by {|x| [x[:index], x[:subindex]]},
            kakes: schedules.map{|schedule| schedule[:kake]},
          )
        }
      end

      def action_schedules
        recipe.actions.map.with_index {|action, i|
          create_action_schedule(
            date: base_date.next_day(action.interval_days),
            action_index: i,
            action: action,
          )
        }
      end

      def rice_schedules
        koji_schedules + kake_schedules
      end

      def schedules
        rice_schedules + action_schedules
      end
    end
  end
end
