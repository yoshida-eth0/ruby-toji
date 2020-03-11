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
            keys = @data.map(&:has_keys).flatten.uniq
          end

          result = []

          keys &= [:temps, :preset_temp, :room_temp, :room_psychrometry, :baume, :acid, :amino_acid, :alcohol]

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

        def plot
          Plotly::Plot.new(
            data: plot_data,
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
      end
    end
  end
end
