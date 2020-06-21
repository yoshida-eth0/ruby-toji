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

        def plot_data(keys=nil)
          @progresses.map {|progress|
            progress.plot_data(keys, true)
          }.inject([], :+)
        end

        def annotations
          @progresses.map {|progress|
            progress.annotations
          }.inject([], :+)
        end

        def plot(keys=nil)
          brews = @progresses.map(&:brew)
          max_brew_days = brews.map(&:days).max
          index = brews.index{|brew| brew.days==max_brew_days}
          day_labels = brews[index].day_labels

          Plotly::Plot.new(
            data: plot_data(keys),
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
      end
    end
  end
end
