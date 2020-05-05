module Toji
  module Brew
    module Graph
      class Progress

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

        attr_reader :brew
        attr_accessor :name
        attr_accessor :dash
        attr_accessor :enable_annotations

        def initialize(brew, name: nil, dash: :solid, enable_annotations: true)
          @brew = brew
          @name = name
          @dash = dash
          @enable_annotations = enable_annotations
        end

        def plot_data(keys=nil, use_name=false)
          if !keys
            keys = @brew.has_keys
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
            @brew.each {|r|
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

            result << {x: xs, y: ys, text: text, name: "#{name}#{key}", line: {dash: @dash, shape: line_shape}, marker: {color: PLOT_COLORS[key]}}
          }

          if 0<@brew.states.length && 0<@brew.day_offset
            result = result.map{|h|
              h[:x].unshift(0)
              h[:y].unshift(nil)
              h[:text].unshift(nil)
              h
            }
          end

          #if 0<@brew.states.length && @brew.states.last.time.strftime("%T")!="00:00:00"
          #  t = @brew.states.last.elapsed_time_with_offset
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
          return [] if @enable_annotations

          @brew.select{|s| s.mark}.map {|s|
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

        def state_group_by(group_by)
          group = {}
          prev = nil

          @brew.each {|state|
            val = state.send(group_by) || prev
            prev = val

            group[val] ||= []
            group[val] << state
          }

          group
        end

        def state_group_count(group_by)
          state_group_by(group_by).map{|val,states|
            [val, states.length]
          }.to_h
        end

        def table_data(keys=nil, group_by=nil, group_count=nil)
          if !keys
            keys = @brew.has_keys
            keys.delete(:elapsed_time)
            keys.delete(:time)
            keys.delete(:day)
            keys.delete(:moromi_day)
            keys.delete(:baume)
            keys.delete(:nihonshudo)
          else
            keys &= @brew.has_keys
          end

          if group_by && group_count
            brew_hash = state_group_by(group_by)
          else
            group_count = state_group_count(:itself)
            brew_hash = state_group_by(:itself)
          end

          rows = []
          group_count.each {|group_value,num|
            states = brew_hash[group_value] || []
            num ||= states.length

            num.times {|i|
              state = states[i]

              rows << keys.map {|k|
                v = state&.send(k)
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
          }

          {header: keys, rows: rows}
        end

        def plot(keys=nil)
          Plotly::Plot.new(
            data: plot_data(keys),
            layout: {
              xaxis: {
                dtick: DAY,
                tickvals: @brew.days.times.map{|d| d*DAY},
                ticktext: @brew.day_labels
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
