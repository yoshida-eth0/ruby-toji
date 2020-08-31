module Toji
  module Brew
    module Graph
      class Ab
        def initialize
          @coef = 1.0
          @actuals = []
          @expects = []
        end

        def coef(coef)
          @coef = coef
          self
        end

        def actual(moromi, name=:actual)
          @actuals << [moromi, name]
          self
        end

        def expect(alcohol, nihonshudo)
          @expects << [alcohol.to_f, nihonshudo.to_f]
          self
        end

        def expects(expects)
          expects.each {|o|
            expect(o.alcohol, o.nihonshudo)
          }
          self
        end

        def plot_data
          result = []

          @actuals.each {|moromi, name|
            states = moromi.wrapped_states.select{|s| s.alcohol && s.baume}

            xs = states.map(&:alcohol)
            ys = states.map(&:baume)
            texts = states.map{|s| "%s<br />alc=%s, be=%s" % [s.display_time, s.alcohol, s.baume]}

            result << {x: xs, y: ys, text: texts, name: name}
          }

          @expects.each {|alcohol, nihonshudo|
            ys = [0.0, 8.0]
            xs = ys.map{|b| alcohol - (b - nihonshudo * -0.1) * @coef}

            name = "%s%s %s" % [nihonshudo<0 ? "" : "+", nihonshudo, alcohol]

            result << {x: xs, y: ys, name: name}
          }

          result
        end

        def min_baume
          @actuals.map {|moromi, name|
            moromi.wrapped_states.map(&:baume).compact.min
          }.compact.min || 0
        end

        def max_baume
          @actuals.map {|moromi, name|
            moromi.wrapped_states.map(&:baume).compact.max
          }.compact.max || 0
        end

        def plot
          #_min_baume = [min_baume-1, 0].min
          _min_baume = 0

          _max_baume = [max_baume+1, 10].max

          Plotly::Plot.new(
            data: plot_data,
            layout: {
              xaxis: {
                title: "Alcohol",
                dtick: 2,
                range: [0, 20],
              },
              yaxis: {
                title: "Baume",
                dtick: 1,
                range: [_min_baume, _max_baume],
              }
            }
          )
        end
      end
    end
  end
end
