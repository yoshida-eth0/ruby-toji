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

        headers += [:moto, :soe, :naka, :tome, :yodan][0...rice_len]
        (5...rice_len).each {|i|
          headers << "#{i}dan"
        }

        _date_rows = date_rows

        rows = []

        date = min_date
        while date<=max_date
          columns = [date.strftime("%m/%d")]

          date_row = _date_rows[date]
          if date_row
            koji_len.times {|i|
              columns << (date_row.kojis[i]&.text || "")
            }
            rice_len.times {|i|
              columns << (date_row.rices[i]&.text || "")
            }
          else
            (koji_len + rice_len).times {
              columns << ""
            }
          end

          rows << columns

          date = date.tomorrow
        end

        {header: headers, rows: rows}
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
              values: data[:rows].transpose
            },
          }],
          layout: {
          }
        )
      end

      def self.load_hash(hash)
        hash = hash.deep_symbolize_keys
        products = hash[:products] || []

        cal = new
        products.each {|product|
          cal.add(Product.create(product))
        }

        cal
      end

      def self.load_yaml_file(fname)
        hash = YAML.load_file(fname)
        load_hash(hash)
      end
    end
  end
end
