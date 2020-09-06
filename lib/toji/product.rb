require 'toji/product/event'
require 'toji/product/rice_event'
require 'toji/product/rice_event_group'

module Toji
  module Product
    attr_reader :reduce_key
    attr_accessor :name
    attr_accessor :recipe
    attr_accessor :base_date

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

    def squeeze_date
      base_date.next_day(recipe.squeeze_interval_days)
    end

    def koji_events
      koji_dates.map.with_index {|date,i|
        RiceEvent.new(
          product: self,
          type: :koji,
          index: i,
          group_index: koji_dates.find_index(date),
          date: date,
          weight: recipe.steps[i].koji,
        )
      }
    end

    def kake_events
      kake_dates.map.with_index {|date,i|
        RiceEvent.new(
          product: self,
          type: :kake,
          index: i,
          group_index: kake_dates.find_index(date),
          date: date,
          weight: recipe.steps[i].kake,
        )
      }
    end

    def rice_events
      koji_events + kake_events
    end

    def koji_event_groups
      koji_events.select{|event|
        0<event.weight
      }.group_by{|event|
        event.group_key
      }.map {|group_key,events|
        RiceEventGroup.new(events)
      }
    end

    def kake_event_groups
      kake_events.select{|event|
        0<event.weight
      }.group_by{|event|
        event.group_key
      }.map {|group_key,events|
        RiceEventGroup.new(events)
      }
    end

    def rice_event_groups
      koji_event_groups + kake_event_groups
    end

    def events
      events = []

      events += rice_event_groups
      events << Event.new(squeeze_date, :squeeze)

      events
    end
  end
end
