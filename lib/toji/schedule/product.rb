module Toji
  module Schedule
    class Product
      attr_reader :id
      attr_reader :name
      attr_reader :description
      attr_reader :recipe

      attr_reader :koji_dates
      attr_reader :rice_dates

      attr_reader :color

      def initialize(id, name, description, recipe, koji_dates, rice_dates, color=nil)
        @id = id
        @name = name
        @description = description
        @recipe = recipe

        @koji_dates = DateIntervalEnumerator.new([], 0).merge(koji_dates, recipe.steps.length)
        @rice_dates = DateIntervalEnumerator.new([recipe.moto_days, recipe.odori_days+1, 1], 1).merge(rice_dates, recipe.steps.length)

        @color = color
      end

      def events
        events = []

        @koji_dates.length.times {|i|
          events << ProductEvent.new(self, :koji, i)
        }

        @rice_dates.length
          .times.map {|i|
            ProductEvent.new(self, :rice, i)
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
          koji_dates: @koji_dates,
          rice_dates: @rice_dates,
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
            recipe = Recipe::ThreeStepMashing::TEMPLATES.fetch(recipe)
          end
          if args[:scale]
            recipe = recipe.scale(args[:scale])
          end
          if args[:round]
            recipe = recipe.round(args[:round])
          end
          if args[:moto_days]
            recipe.moto_days = args[:moto_days]
          end
          if args[:odori_days]
            recipe.odori_days = args[:odori_days]
          end

          new(
            args[:id],
            args[:name],
            args[:description],
            recipe,
            args[:koji_dates],
            args[:rice_dates],
            args[:color]
          )
        else
          raise "not supported class: #{args.class}"
        end
      end
    end
  end
end
