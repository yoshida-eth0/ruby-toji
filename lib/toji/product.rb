require 'toji/product/event'
require 'toji/product/rice_event'
require 'toji/product/rice_event_group'
require 'toji/product/action_event'
require 'toji/product/event_factory'

module Toji
  module Product
    attr_reader :reduce_key
    attr_accessor :name
    attr_accessor :recipe
    attr_accessor :base_date

    attr_accessor :koji_events
    attr_accessor :kake_events
    attr_accessor :koji_event_groups
    attr_accessor :kake_event_groups
    attr_accessor :action_events

    def koji_dates
      date = base_date
      recipe.steps.map {|step|
        date = date.next_day(step.koji_interval_days)
      }
    end

    def kake_dates
      date = base_date
      recipe.steps.map {|step|
        date = date.next_day(step.kake_interval_days)
      }
    end

    def action_dates
      date = base_date
      recipe.actions.map {|action|
        date = date.next_day(action.interval_days)
      }
    end

    def rice_events
      koji_events + kake_events
    end

    def rice_event_groups
      koji_event_groups + kake_event_groups
    end

    def events
      rice_event_groups + action_events
    end
  end
end
