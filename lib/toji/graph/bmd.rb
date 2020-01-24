module Toji
  module Graph
    class Bmd

      def initialize
        @actuals = []
        @expects = []
      end

      def actual(moromi, name=:actual)
        @actuals << [moromi, name]
        self
      end

      def data
        result = []

        @actuals.each {|moromi, name|
          jobs = moromi.select{|j| j.moromi_time && j.bmd}

          xs = jobs.map(&:moromi_time)
          ys = jobs.map(&:bmd)
          texts = jobs.map{|j| "%s<br />moromi day=%d, be=%s, bmd=%s" % [j.time || j.elapsed_time + moromi.day_offset, j.moromi_day, j.baume, j.bmd]}

          result << {x: xs, y: ys, text: texts, name: name}
        }

        result
      end

      def max_moromi_day
        @actuals.map(&:first).map(&:moromi_days).max
      end

      def plot
        _max_moromi_day = [max_moromi_day, 14].max

        Plotly::Plot.new(
          data: data,
          layout: {
            xaxis: {
              title: "Moromi day",
              dtick: Product::Job::DAY,
              range: [1, _max_moromi_day].map{|d| d*Product::Job::DAY},
              tickvals: _max_moromi_day.times.map{|d| d*Product::Job::DAY},
              ticktext: _max_moromi_day.times.map(&:succ)
            },
            yaxis: {
              title: "BMD",
            }
          }
        )
      end
    end
  end
end
