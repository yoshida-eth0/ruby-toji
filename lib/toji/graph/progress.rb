module Toji
  module Graph
    class Progress

      def initialize(product)
        @product = product
      end

      def data(keys=nil)
        data = @product.map(&:to_h).map(&:compact)
        if !keys
          keys = data.map(&:keys).flatten.uniq
        end

        result = []

        keys &= [:temps, :preset_temp, :room_temp, :room_psychrometry, :baume, :acid, :amino_acid, :alcohol]

        keys.each {|key|
          xs = []
          ys = []
          text = []
          data.each {|h|
            if h[key]
              [h[key]].flatten.each_with_index {|v,i|
                xs << h[:elapsed_time] + i + @product.day_offset
                ys << v
                text << h[:display_time]
              }
            end
          }

          line_shape = :linear
          if key==:preset_temp
            line_shape = :hv
          end

          result << {x: xs, y: ys, text: text, name: key, line: {shape: line_shape}}
        }

        if 0<@product.day_offset
          result = result.map{|h|
            h[:x].unshift(0)
            h[:y].unshift(nil)
            h[:text].unshift(nil)
            h
          }
        end

        result
      end

      def plot
        Plotly::Plot.new(
          data: data,
          layout: {
            xaxis: {
              dtick: Product::Job::DAY,
              tickvals: @product.days.times.map{|d| d*Product::Job::DAY},
              ticktext: @product.day_labels
            }
          }
        )
      end
    end
  end
end
