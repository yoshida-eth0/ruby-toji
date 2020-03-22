module Toji
  module Schedule
    class Product
      attr_reader :name
      attr_reader :description
      attr_reader :recipe

      attr_reader :koji_dates
      attr_reader :rice_dates

      attr_reader :color

      def initialize(name, description, recipe, koji_dates, rice_dates, color=nil)
        @name = name
        @description = description
        @recipe = recipe

        @koji_dates = merge_date_enum(koji_dates, koji_date_interval_enumerator)
        @rice_dates = merge_date_enum(rice_dates, rice_date_interval_enumerator)

        @color = color
      end

      def merge_date_enum(dates, date_enum)
        dates = [dates].flatten.map{|d| d&.to_time}

        @recipe.steps.length.times {|i|
          add = date_enum.next

          if i==0
            dates[i] = dates[i]
          elsif !dates[i] && dates[i-1]
            dates[i] = dates[i-1].since(add.days)
          end
        }

        dates
      end

      def date_interval_enumerator(intervals, afterwards)
        Enumerator.new do |y|
          y << 0
          intervals.each {|interval|
            y << interval
          }
          loop {
            y << afterwards
          }
        end.each
      end

      def koji_date_interval_enumerator
        date_interval_enumerator([], 0)
      end

      def rice_date_interval_enumerator
        date_interval_enumerator([1,2,1], 1)
      end

      def events
        events = []

        @koji_dates
          .each_with_index
          .select {|d,i| d}
          .each {|d,i|
            events << ProductEvent.new(self, :koji, i)
          }

        @rice_dates
          .each_with_index
          .select {|d,i| d}
          .each {|d,i|
            events << ProductEvent.new(self, :rice, i)
          }

        events
      end

      def self.create(args)
        if self===args
          args
        elsif Hash===args
          recipe = args.fetch(:recipe)
          if Symbol===recipe
            recipe = Recipe::ThreeStepMashing::TEMPLATES[recipe]
          end
          if args[:scale]
            recipe = recipe.scale(args[:scale])
          end
          if args[:round]
            recipe = recipe.round(args[:round])
          end

          new(
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
