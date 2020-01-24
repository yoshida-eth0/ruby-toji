module Toji
  module Graph
    class Ab
      attr_reader :coef

      def initialize(coef=1.5)
        @coef = coef
        @actuals = []
        @expects = []
      end

      def actual(moromi, name=:actual)
        @actuals << [moromi, name]
        self
      end

      def expect(alcohol, nihonshudo)
        @expects << [alcohol.to_f, nihonshudo.to_f]
        self
      end

      def data
        result = []

        @actuals.each {|moromi, name|
          data = moromi.map{|j| [j.time || j.elapsed_time + moromi.day_offset, j.alcohol, j.baume]}.select{|a| a[1] && a[2]}

          xs = data.map{|a| a[1]}
          ys = data.map{|a| a[2]}
          texts = data.map{|a| "%s<br />alc=%s, be=%s" % a}

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
        data.map{|h| h[:y].min}.min || 0
      end

      def max_baume
        data.map{|h| h[:y].max}.max || 0
      end

      def plot
        #_min_baume = [min_baume-1, 0].min
        _min_baume = 0

        _max_baume = [max_baume+1, 10].max

        Plotly::Plot.new(
          data: data,
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
