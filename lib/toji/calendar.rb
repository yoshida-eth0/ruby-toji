require 'toji/calendar/date_row'
require 'toji/calendar/date_column'

module Toji
  class Calendar
    attr_reader :products

    def initialize
      @products = []
    end

    def <<(product)
      @products += [product].flatten
      self
    end
    alias_method :add, :<<

    def date_rows
      events = @products.map{|product| product.rice_events}.flatten

      result = {}
      events.each {|event|
        result[event.date] ||= DateRow.new(event.date)
        result[event.date] << event
      }

      result
    end

    def table_data
      events = @products.map{|product| product.rice_events}.flatten

      koji_len = events.select{|e| e.rice_type==:koji}.map{|e| e.indexes.first}.max + 1
      kake_len = events.select{|e| e.rice_type==:kake}.map{|e| e.indexes.first}.max + 1
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

      headers += [:moto, :soe, :naka, :tome, :yodan][0...kake_len]
      (5...kake_len).each {|i|
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
            columns << date_row.kojis[i]
          }
          kake_len.times {|i|
            columns << date_row.kakes[i]
          }
        else
          (koji_len + kake_len).times {
            columns << []
          }
        end

        rows << columns

        date = date.tomorrow
      end

      {header: headers, rows: rows}
    end

    def table_text_data
      data = table_data
      data[:rows] = data[:rows].map {|row|
        row.map {|column|
          if DateColumn===column
            column.text
          elsif column
            column
          else
            ""
          end
        }
      }
      data
    end

    def table
      data = table_text_data

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
  end
end
