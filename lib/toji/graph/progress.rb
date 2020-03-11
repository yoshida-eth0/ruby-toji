module Toji
  module Graph
    class Progress

      attr_accessor :enable_annotations

      def initialize(rows, enable_annotations: true)
        @rows = rows
        @enable_annotations = enable_annotations
      end

      def data(keys=nil)
        if !keys
          keys = @rows.map(&:has_keys).flatten.uniq
        end

        result = []

        keys &= [:temps, :preset_temp, :room_temp, :room_psychrometry, :baume, :acid, :amino_acid, :alcohol]

        keys.each {|key|
          xs = []
          ys = []
          text = []
          @rows.each {|r|
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

        if 0<rows.length && 0<@rows.first.day_offset
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
        @rows.select{|r| r.job.id}.map {|r|
          {
            x: r.elapsed_time_with_offset,
            y: r.job.temps.first || 0,
            xref: 'x',
            yref: 'y',
            text: r.job..id,
            showarrow: true,
            arrowhead: 1,
            ax: 0,
            ay: -40
          }
        }
      end

      def plot
        Plotly::Plot.new(
          data: data,
          layout: {
            xaxis: {
              dtick: Product::Job::DAY,
              tickvals: @rows.days.times.map{|d| d*Product::Job::DAY},
              ticktext: @rows.day_labels
            },
            annotations: @enable_annotations ? annotations : [],
          }
        )
      end
    end
  end
end
