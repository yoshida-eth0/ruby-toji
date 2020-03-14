module Toji
  module Brew
    module Graph
      class Progress

        attr_accessor :enable_annotations

        def initialize(data, enable_annotations: true)
          @data = data
          @enable_annotations = enable_annotations
        end

        def plot_data(keys=nil)
          if !keys
            keys = @data.has_keys
          end

          result = []

          keys &= [:temps, :preset_temp, :room_temp, :room_psychrometry, :baume, :acid, :amino_acid, :alcohol, :bmd]

          keys.each {|key|
            xs = []
            ys = []
            text = []
            @data.each {|r|
              val = r.send(key)
              if val
                [val].flatten.each_with_index {|v,i|
                  xs << r.elapsed_time_with_offset + i
                  ys << v
                  text << r.display_time
                }
              end
            }

            line_shape = :linear
            if key==:preset_temp
              line_shape = :hv
            end

            result << {x: xs, y: ys, text: text, name: key, line: {shape: line_shape}}
          }

          if 0<@data.states.length && 0<@data.day_offset
            result = result.map{|h|
              h[:x].unshift(0)
              h[:y].unshift(nil)
              h[:text].unshift(nil)
              h
            }
          end

          result
        end

        def annotations
          @data.select{|s| s.mark}.map {|s|
            {
              x: s.elapsed_time_with_offset,
              y: s.temps.first || 0,
              xref: 'x',
              yref: 'y',
              text: s.mark,
              showarrow: true,
              arrowhead: 1,
              ax: 0,
              ay: -40
            }
          }
        end

        def table_data(keys=nil)
          if !keys
            keys = @data.has_keys
            keys.delete(:elapsed_time)
            keys.delete(:time)
            keys.delete(:day)
            keys.delete(:moromi_day)
            keys.delete(:baume)
            keys.delete(:nihonshudo)
            keys.delete(:warming)
          else
            keys &= @data.has_keys
          end

          cells = @data.map {|s|
            keys.map {|k|
              v = s.send(k)
              if Array===v
                v.map(&:to_s).join(", ")
              elsif Float===v
                v.round(3)
              elsif v
                v
              else
                ""
              end
            }
          }

          {header: keys, cells: cells.transpose}
        end

        def plot(keys=nil)
          Plotly::Plot.new(
            data: plot_data(keys),
            layout: {
              xaxis: {
                dtick: DAY,
                tickvals: @data.days.times.map{|d| d*DAY},
                ticktext: @data.day_labels
              },
              annotations: @enable_annotations ? annotations : [],
            }
          )
        end

        def table(keys=nil)
          data = table_data(keys)

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
end
