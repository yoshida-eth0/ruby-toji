module Toji
  module Progress
    module Graph
      class ProgressNote

        PLOT_KEYS = [:temps, :preset_temp, :room_temp, :room_psychrometry, :baume, :acid, :amino_acid, :alcohol, :bmd].freeze

        COLORS = [
          '#1f77b4',  # muted blue
          '#ff7f0e',  # safety orange
          '#2ca02c',  # cooked asparagus green
          '#d62728',  # brick red
          '#9467bd',  # muted purple
          '#8c564b',  # chestnut brown
          '#e377c2',  # raspberry yogurt pink
          '#7f7f7f',  # middle gray
          '#bcbd22',  # curry yellow-green
          '#17becf'   # blue-teal
        ].freeze

        PLOT_COLORS = Hash[PLOT_KEYS.zip(COLORS)].freeze

        LINE_DASHES = [
          :solid,
          :dot,
          :dashdot,
        ].freeze

        attr_reader :progress
        attr_accessor :name
        attr_accessor :dash
        attr_accessor :enable_annotations

        def initialize(progress, name: nil, dash: :solid, enable_annotations: true)
          @progress = progress
          @name = name
          @dash = dash
          @enable_annotations = enable_annotations
        end

        def plot_data(keys=nil, use_name=false)
          if !keys
            keys = @progress.has_keys
          end

          name = ""
          if use_name && @name
            name = "#{@name} "
          end

          result = []

          keys &= PLOT_KEYS

          keys.each {|key|
            xs = []
            ys = []
            text = []
            @progress.states.each {|s|
              val = s.send(key)
              if val
                [val].flatten.each_with_index {|v,i|
                  xs << s.elapsed_time_with_offset + i
                  ys << v
                  text << s.display_time
                }
              end
            }

            line_shape = :linear
            if key==:preset_temp
              line_shape = :hv
            end

            result << {x: xs, y: ys, text: text, name: "#{name}#{key}", line: {dash: @dash, shape: line_shape}, marker: {color: PLOT_COLORS[key]}}
          }

          if 0<@progress.states.length && 0<@progress.day_offset
            result = result.map{|h|
              h[:x].unshift(0)
              h[:y].unshift(nil)
              h[:text].unshift(nil)
              h
            }
          end

          #if 0<@progress.states.length && @progress.states.last.time.strftime("%T")!="00:00:00"
          #  t = @progress.states.last.elapsed_time_with_offset
          #  t -= (t % DAY) - DAY
          #
          #  result = result.map{|h|
          #    h[:x] << t
          #    h[:y] << nil
          #    h[:text] << nil
          #    h
          #  }
          #end

          result
        end

        def annotations
          return [] if !@enable_annotations

          @progress.states.select{|s| s.mark}.map {|s|
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
            keys = @progress.has_keys
            keys.delete(:elapsed_time)
            keys.delete(:time)
            keys.delete(:day)
            keys.delete(:moromi_day)
            if keys.include?(:display_baume)
              keys.delete(:baume)
              keys.delete(:nihonshudo)
            end
          else
            keys &= @progress.has_keys
          end

          rows = []
          @progress.states.each {|state|
            rows << keys.map {|k|
              v = state&.send(k)
              if Array===v
                v.map(&:to_s).join(", ")
              elsif Float===v
                v.round(3).to_s
              elsif v
                v.to_s
              else
                ""
              end
            }
          }

          {header: keys, rows: rows}
        end

        def plot(keys=nil)
          Plotly::Plot.new(
            data: plot_data(keys),
            layout: {
              xaxis: {
                dtick: DAY,
                tickvals: @progress.days.times.map{|d| d*DAY},
                ticktext: @progress.day_labels
              },
              annotations: annotations,
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
                values: data[:rows].transpose
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
