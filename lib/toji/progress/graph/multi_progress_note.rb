module Toji
  module Progress
    module Graph
      class MultiProgressNote

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
          when ProgressNote
            progress = source.dup
            progress.name = name
            progress.dash = dash
            progress.enable_annotations = enable_annotations
          when Progress
            progress = source.progress_note(name: name, dash: dash, enable_annotations: enable_annotations)
          else
            raise Error, "ArgumentError: Toji::Progress::Graph::ProgressNote or Toji::Progress::Progress required"
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
          progresses = @progresses.map(&:progress)
          max_days = progresses.map(&:days).max
          index = progresses.index{|progress| progress.days==max_days}
          day_labels = progresses[index].day_labels

          Plotly::Plot.new(
            data: plot_data(keys),
            layout: {
              xaxis: {
                dtick: DAY,
                tickvals: max_days.times.map{|d| d*DAY},
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
