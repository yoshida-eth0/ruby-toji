module Toji
  module Progress
    module Graph
      class Bmd

        def initialize
          @actuals = []
        end

        def actual(moromi, name=:actual)
          @actuals << [moromi, name]
          self
        end

        def plot_data
          result = []

          @actuals.each {|moromi, name|
            states = moromi.states.select{|s| s.moromi_day && s.bmd}

            xs = states.map(&:moromi_day).map{|d| d*DAY}
            ys = states.map(&:bmd)
            texts = states.map{|s| "%s<br />moromi day=%d, be=%s, bmd=%s" % [s.display_time, s.moromi_day, s.baume, s.bmd]}

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
            data: plot_data,
            layout: {
              xaxis: {
                title: "Moromi day",
                dtick: DAY,
                range: [1, _max_moromi_day].map{|d| d*DAY},
                tickvals: _max_moromi_day.times.map{|d| d*DAY},
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
end
