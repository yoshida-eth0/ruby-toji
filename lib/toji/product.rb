require 'toji/product/event'
require 'toji/product/date_interval_enumerator'

module Toji
  class Product
    attr_reader :id
    attr_reader :name
    attr_reader :description
    attr_reader :recipe
    attr_reader :start_date
    attr_reader :color

    def initialize(id, name, description, recipe, start_date, color=nil)
      @id = id
      @name = name
      @description = description
      @recipe = recipe
      @start_date = start_date
      @color = color
    end

    def koji_dates
      date = start_date
      @recipe.steps.map {|step|
        date = date.next_day(step.koji_interval_days)
      }
    end

    def rice_dates
      date = start_date
      @recipe.steps.map {|step|
        date = date.next_day(step.rice_interval_days)
      }
    end

    def events
      events = []

      @koji_dates.length.times {|i|
        events << Event.new(self, :koji, i)
      }

      @rice_dates.length
        .times.map {|i|
          Event.new(self, :rice, i)
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

    def to_h
      {
        id: @id,
        name: @name,
        description: @description,
        recipe: @recipe.table_data,
        start_date: @start_date,
        koji_dates: koji_dates,
        rice_dates: rice_dates,
        events: events.map(&:to_h),
        events_group: events_group,
        color: @color,
      }
    end

    def self.create(args)
      if self===args
        args
      elsif Hash===args
        recipe = args.fetch(:recipe)
        if Symbol===recipe
          recipe = Recipe::TEMPLATES.fetch(recipe)
        end
        if args[:scale]
          recipe = recipe.scale(args[:scale])
        end
        if args[:round]
          recipe = recipe.round(args[:round])
        end

        new(
          args[:id],
          args[:name],
          args[:description],
          recipe,
          args[:start_date],
          args[:color]
        )
      else
        raise "not supported class: #{args.class}"
      end
    end
  end
end
