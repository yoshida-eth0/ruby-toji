require 'toji/product/schedule_factory'

module Toji
  module Product
    attr_accessor :name
    attr_accessor :recipe
    attr_accessor :base_date

    attr_accessor :koji_schedules
    attr_accessor :kake_schedules
    attr_accessor :action_schedules

    def koji_dates
      date = base_date
      recipe.steps.map {|step|
        date = date.next_day(step.koji&.interval_days || 0)
      }
    end

    def kake_dates
      date = base_date
      recipe.steps.map {|step|
        date = date.next_day(step.kake&.interval_days || 0)
      }
    end

    def action_dates
      date = base_date
      recipe.actions.map {|action|
        date = date.next_day(action.interval_days)
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
