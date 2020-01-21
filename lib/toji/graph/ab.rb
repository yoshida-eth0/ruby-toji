module Toji
  module Graph
    class Ab
      attr_reader :coef

      def initialize(coef=1.5)
        @coef = coef
        @actuals = []
        @expects = []
      end

      def actual(jobs, name=:actual)
        data = jobs.map{|j| [j.time || j.elapsed_time + jobs.day_offset, j.alcohol, j.baume]}.select{|a| a[1] && a[2]}
        xs = data.map{|a| a[1]}
        ys = data.map{|a| a[2]}
        texts = data.map{|a| "%s<br />alc=%s, be=%s" % a}
        @actuals << {x: xs, y: ys, text: texts, name: name}

        self
      end

      def expect(alcohol, nihonshudo)
        @expects << [alcohol.to_f, nihonshudo.to_f]

        self
      end

      def data
        result = []

        @actuals.each {|a|
          result << a
        }

        @expects.each {|alcohol, nihonshudo|
          ys = [0.0, 8.0]
          xs = ys.map{|b| alcohol - (b - nihonshudo * -0.1) * @coef}

          name = "%s%s %s" % [nihonshudo<0 ? "" : "+", nihonshudo, alcohol]

          result << {x: xs, y: ys, name: name}
        }

        result
      end

      def plot
        d = data

        #min_baume = d.map{|h| h[:y].min}.min || 0
        #min_baume = [min_baume-1, 0].min
        min_baume = 0

        max_baume = d.map{|h| h[:y].max}.max || 0
        max_baume = [max_baume+1, 10].max

        Plotly::Plot.new(
          data: d,
          layout: {
            xaxis: {
              title: "Alcohol",
              dtick: 2,
              range: [0, 20],
            },
            yaxis: {
              title: "Baume",
              dtick: 1,
              range: [min_baume, max_baume],
            }
          }
        )
      end
    end
  end
end
