module Toji
  module Brew
    module Graph
      class MultiProgress

        LINE_DASHES = [
          :solid,
          :dot,
          :dashdot,
        ].freeze

        def initialize
          @progresses = []
        end

        def <<(source, name=nil, dash: nil, enable_annotations: true)
          if !dash
            dash = LINE_DASHES[@progresses.length % LINE_DASHES.length]
          end

          if !name
            name = "Progress #{@progresses.length}"
          end

          case source
          when Progress
            progress = source.dup
            progress.name = name
            progress.dash = dash
            progress.enable_annotations = enable_annotations
          when Base
            progress = source.progress(name: name, dash: dash, enable_annotations: enable_annotations)
          else
            raise Error, "ArgumentError: Progress or Base required"
          end

          @progresses << progress
          self
        end
        alias_method :add, :<<


        def plot(keys=nil)
          data = []
          annotations = []
          use_name = 2<=@progresses.length

          @progresses.each {|progress|
            data += progress.plot_data(keys, use_name)
            annotations += progress.annotations
          }

          brews = @progresses.map(&:brew)
          max_brew_days = brews.map(&:days).max
          index = brews.index{|brew| brew.days==max_brew_days}
          day_labels = brews[index].day_labels

          Plotly::Plot.new(
            data: data,
            layout: {
              xaxis: {
                dtick: DAY,
                tickvals: max_brew_days.times.map{|d| d*DAY},
                ticktext: day_labels
              },
              annotations: annotations,
            }
          )
        end

        def state_group_order(group_by)
          result = {}

          @progresses.map{|progress|
            progress.state_group_by(group_by)
          }.map{|group|
            group.map{|key,states|
              [key, states.first.elapsed_time_with_offset]
            }.to_h
          }.each {|group|
            result.merge!(group) {|key,self_val,other_val|
              [self_val, other_val].min
            }
          }

          result.sort_by(&:last).map(&:first)
        end

        def state_group_count(group_by)
          result = {}

          @progresses.map{|progress|
            progress.state_group_count(group_by)
          }.each {|group|
            result.merge!(group) {|key,self_val,other_val|
              [self_val, other_val].max
            }
          }

          result2 = {}
          state_group_order(group_by).each{|val|
            result2[val] = result[val]
          }
          result2
        end

        def table_group_by(group_by, keys=nil)
          header = []
          cells = []

          group_count = state_group_count(group_by)

          header << ["", group_by]
          cells << group_count.inject([]) {|result,(group,num)|
            if 0<num
              result << group
              (num-1).times {
                result << ""
              }
            end
            result
          }

          @progresses.each {|progress|
            data = progress.table_data(keys, group_by, group_count)
            header += data[:header].map.with_index{|h,i|
              name = i==0 ? progress.name : ""
              [name, h]
            }
            cells += data[:cells]
          }

          Plotly::Plot.new(
            data: [{
              type: :table,
              header: {
                values: header
              },
              cells: {
                values: cells
              },
            }],
            layout: {
            }
          )
        end

        def table(keys=nil, date_format="%m/%d %H:%M")
          header = []
          cells = []

          elapsed_times = state_group_count(:elapsed_time_with_offset)

          header << ["", :elapsed_time]
          utc_offset = Time.at(0).utc_offset

          cells << elapsed_times.inject([]) {|result,(elapsed_time,num)|
            if 0<num
              result << Time.at(elapsed_time - utc_offset).strftime(date_format)
              (num-1).times {
                result << ""
              }
            end
            result
          }

          @progresses.each {|progress|
            data = progress.table_data(keys, :elapsed_time_with_offset, elapsed_times)
            header += data[:header].map.with_index{|h,i|
              name = i==0 ? progress.name : ""
              [name, h]
            }
            cells += data[:cells]
          }

          Plotly::Plot.new(
            data: [{
              type: :table,
              header: {
                values: header
              },
              cells: {
                values: cells
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
