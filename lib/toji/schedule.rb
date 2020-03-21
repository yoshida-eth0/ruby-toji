module Toji
  module Schedule

    class Calendar
      def initialize
        @products = []
      end

      def <<(product)
        @products << product
        self
      end
      alias_method :add, :<<

      def date_rows
        events = @products.map{|product| product.events}.flatten

        result = {}
        events.each {|event|
          result[event.date] ||= DateRow.new(event.date)
          result[event.date] << event
        }

        result
      end

      def table_data
        events = @products.map{|product| product.events}.flatten

        koji_len = events.select{|e| e.type==:koji}.map(&:group_index).max + 1
        rice_len = events.select{|e| e.type==:rice}.map(&:group_index).max + 1
        min_date = events.map(&:date).min
        max_date = events.map(&:date).max

        headers = [:date]

        case koji_len
        when 1
          headers += [:koji]
        when 2
          headers += [:moto_koji, :moromi_koji]
        else
          headers += [:moto_koji]
          (2..koji_len).each {|i|
            headers << "moromi_koji#{i-1}"
          }
        end

        case rice_len
        when 1
          headers += [:moto]
        when 2
          headers += [:moto, :soe]
        when 3
          headers += [:moto, :soe, :naka]
        when 4
          headers += [:moto, :soe, :naka, :tome]
        else
          headers += [:moto, :soe, :naka, :tome]
          (4..rice_len).each {|i|
            headers << "#{i}dan"
          }
        end

        rows = date_rows

        cells = []

        date = min_date
        while date<=max_date
          columns = [date.strftime("%m/%d")]

          row = rows[date]
          if row
            koji_len.times {|i|
              columns << (row.kojis[i]&.text || "")
            }
            rice_len.times {|i|
              columns << (row.rices[i]&.text || "")
            }
          else
            (koji_len + rice_len).times {
              columns << ""
            }
          end

          cells << columns

          date = date.tomorrow
        end

        {header: headers, cells: cells.transpose}
      end

      def table
        data = table_data

        Plotly::Plot.new(
          data: [{
            type: :table,
            header: {
              values: data[:header]
            },
            cells: {
              values: data[:cells]
            },
          }],
          layout: {
          }
        )
      end
    end

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

    class ProductEvent
      attr_reader :product
      attr_reader :type
      attr_reader :index
      
      def initialize(product, type, index)
        @product = product
        @type = type
        @index = index
      end

      def date
        method = "#{@type}_dates".to_sym
        @product.send(method)[@index]
      end

      def group_index
        method = "#{@type}_dates".to_sym
        dates = @product.send(method)
        date = dates[@index]
        dates.index(date)
      end

      def group_key
        a = []
        a << product.name
        a << type
        a << group_index
        a.map(&:to_s).join(":")
      end

      def weight
        @product.recipe.steps[@index].send(@type).raw
      end
    end

    class DateRow
      attr_reader :date
      attr_reader :kojis
      attr_reader :rices

      def initialize(date)
        @date = date
        @kojis = []
        @rices = []
      end

      def <<(event)
        case event.type
        when :koji
          index = event.group_index
          @kojis[index] ||= DateColumn.new
          @kojis[index] << event
        when :rice
          index = event.group_index
          @rices[index] ||= DateColumn.new
          @rices[index] << event
        end
      end
      alias_method :add, :<<
    end

    class DateColumn
      attr_reader :events

      def initialize
        @events = []
      end

      def <<(event)
        @events << event
      end
      alias_method :add, :<<

      def event_groups
        @events.group_by {|e|
          e.group_key
        }.values
      end

      def text
        event_groups.map {|es|
          name = es.first.product.name
          weight = es.map(&:weight).sum
          "#{name}: #{weight}"
        }.join(", ")
      end
    end
  end
end
