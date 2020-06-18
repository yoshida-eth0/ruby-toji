require 'toji/product/event'

module Toji
  module Product
    attr_reader :reduce_key
    attr_accessor :name
    attr_accessor :recipe
    attr_accessor :start_date

    def koji_dates
      date = start_date
      recipe.steps.map {|step|
        date = date.next_day(step.koji_interval_days)
      }
    end

    def kake_dates
      date = start_date
      recipe.steps.map {|step|
        date = date.next_day(step.kake_interval_days)
      }
    end

    def events
      events = []

      koji_dates.length.times {|i|
        events << Event.new(self, :koji, i)
      }

      kake_dates.length
        .times.map {|i|
          Event.new(self, :kake, i)
        }
        .delete_if {|e|
          4<=e.index && e.weight==0
        }
        .each {|e|
          events << e
        }

      events
    end

    def events_group
      events.group_by{|event|
        event.group_key
      }.map {|group_key,events|
        breakdown = events.map {|event|
          {index: event.index, weight: event.weight}
        }
        if 1<breakdown.length
          breakdown = breakdown.select{|event| 0<event[:weight]}
        end

        {
          date: events.first.date,
          type: events.first.type,
          weight: events.map(&:weight).sum,
          breakdown: breakdown,
        }
      }
    end
  end
end
