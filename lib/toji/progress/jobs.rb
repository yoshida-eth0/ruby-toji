module Toji
  module Progress
    class Jobs
      include Enumerable

      attr_reader :day_offset

      def initialize(arr)
        @arr = []
        @hash = {}
        @day_offset = 0

        arr.each {|j|
          self << j
        }
      end

      def [](id)
        @hash[id]
      end

      def <<(job)
        if job.id
          if @hash[job.id]
            @arr.delete(@hash[job.id])
          end
          @hash[job.id] = job
        end
        @arr << job
        job.jobs = self
        normalization
      end

      def normalization
        min_time = @arr.select{|j| j.time}.map(&:time).sort.first

        if min_time
          @arr.each {|j|
            if j.time
              j.elapsed_time = (j.time - min_time).to_i
            else
              j.time = min_time + j.elapsed_time
            end
          }
        end

        @arr = @arr.sort{|a,b| a.elapsed_time<=>b.elapsed_time}

        t = @arr.first&.time
        if t
          @day_offset = t - Time.mktime(t.year, t.month, t.day)
        else
          @day_offset = 0
        end
      end

      def each(&block)
        normalization
        @arr.each(&block)
      end

      def plot_data(keys=nil)
        normalization

        data = map(&:to_h).map(&:compact)
        if !keys
          keys = data.map(&:keys).flatten.uniq
        end

        result = []

        if keys.include?(:temps)
          temps = data.map{|h| h[:temps]}
          if 0<temps.select{|a| a.present?}.size
            temps_x = []
            temps_y = []
            temps.each_with_index {|ts,i|
              ts.each_with_index {|t,j|
                temps_x << data[i][:elapsed_time] + j + day_offset
                temps_y << t
              }
            }
            result << {x: temps_x, y: temps_y, name: :temps}
          end
        end

        keys &= [:preset_temp, :room_temp, :room_psychrometry, :baume, :acid, :amino_acid, :alcohol]

        keys.each {|key|
          xs = []
          ys = []
          data.each {|h|
            if h[key]
              ys << h[key]
              xs << h[:elapsed_time] + day_offset
            end
          }

          line_shape = :linear
          if key==:preset_temp
            line_shape = :hv
          end

          result << {x: xs, y: ys, name: key, line: {shape: line_shape}}
        }

        if 0<day_offset
          result = result.map{|h|
            h[:x].unshift(0)
            h[:y].unshift(nil)
            h
          }
        end

        result
      end

      def bmd_plot_data
        normalization

        data = map{|j| [j.time || j.elapsed_time + day_offset, j.moromi_time, j.moromi_day, j.baume, j.bmd]}.select{|a| a[1] && a[4]}
        xs = data.map{|a| a[1]}
        ys = data.map{|a| a[4]}
        texts = data.map{|a| "%s<br />moromi day=%d, be=%s, bmd=%s" % [a[0], a[2], a[3], a[4]]}

        {x: xs, y: ys, text: texts, name: :bmd}
      end

      def ab_plot_data
        normalization

        result = []

        data = map{|j| [j.time || j.elapsed_time + day_offset, j.alcohol, j.baume]}.select{|a| a[1] && a[2]}
        xs = data.map{|a| a[1]}
        ys = data.map{|a| a[2]}
        texts = data.map{|a| "%s<br />alc=%s, be=%s" % a}
        {x: xs, y: ys, text: texts, name: :actual}
      end
    end
  end
end
