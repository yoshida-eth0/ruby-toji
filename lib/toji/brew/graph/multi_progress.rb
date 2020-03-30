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

        def table(keys=nil, date_format="%m/%d %H:%M")
          header = []
          cells = []

          elapsed_times = @progresses.map {|progress|
            progress.brew.map(&:elapsed_time_with_offset)
          }.flatten.sort.uniq

          header << ["", :elapsed_time]
          utc_offset = Time.at(0).utc_offset

          cells << elapsed_times.map {|elapsed_time|
            Time.at(elapsed_time - utc_offset).strftime(date_format)
          }

          @progresses.each {|progress|
            data = progress.table_data(keys, elapsed_times)
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
