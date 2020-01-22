module Toji
  module Product
    class Base
      include Enumerable
      extend JobAccessor

      attr_accessor :date_line
      attr_reader :day_offset

      def initialize(arr=[], date_line: 0)
        @_arr = []
        @_hash = {}
        @date_line = date_line
        @day_offset = 0

        arr.each {|j|
          self << j
        }
      end

      def [](id)
        @_hash[id]
      end

      def <<(job)
        if job.id
          if @_hash[job.id]
            @_arr.delete(@_hash[job.id])
          end
          @_hash[job.id] = job
        end
        @_arr << job
        job.jobs = self
        _normalization
        self
      end
      alias_method :add, :<<

      def _normalization
        min_time = @_arr.select{|j| j.time}.map(&:time).sort.first

        if min_time
          @_arr.each {|j|
            if j.time
              j.elapsed_time = (j.time - min_time).to_i
            else
              j.time = min_time + j.elapsed_time
            end
          }
        end

        @_arr = @_arr.sort{|a,b| a.elapsed_time<=>b.elapsed_time}

        t = @_arr.first&.time
        if t
          @day_offset = t - Time.mktime(t.year, t.month, t.day)
        else
          @day_offset = 0
        end
        @day_offset += ((24 - @date_line) % 24) * Job::HOUR
      end

      def each(&block)
        _normalization
        @_arr.each(&block)
      end

      def bmd_plot_data
        _normalization

        data = map{|j| [j.time || j.elapsed_time + day_offset, j.moromi_time, j.moromi_day, j.baume, j.bmd]}.select{|a| a[1] && a[4]}
        xs = data.map{|a| a[1]}
        ys = data.map{|a| a[4]}
        texts = data.map{|a| "%s<br />moromi day=%d, be=%s, bmd=%s" % [a[0], a[2], a[3], a[4]]}

        {x: xs, y: ys, text: texts, name: :bmd}
      end
    end
  end
end
