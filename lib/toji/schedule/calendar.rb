module Toji
  module Schedule
    class Calendar
      attr_reader :products

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
          (4...rice_len).each {|i|
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
  end
end
