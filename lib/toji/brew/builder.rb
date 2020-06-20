module Toji
  module Brew
    class Builder

      def initialize(cls)
        @cls = cls
        @states = []
        @date_line = 0
        @prefix_day_labels = nil
      end

      def <<(state)
        @states += [state].flatten.map {|state|
          State.create(state)
        }
        self
      end
      alias_method :add, :<<

      def date_line(val, unit=SECOND)
        @date_line = (val * unit).to_i
        self
      end

      def prefix_day_labels(val)
        @prefix_day_labels = val
        self
      end

      def build
        brew = @cls.new

        min_time = @states.map(&:time).compact.sort.first
        wrappers = @states.map{|r| StateWrapper.new(r.elapsed_time, r, brew)}

        # time
        if min_time
          wrappers.each {|w|
            if w.state.time
              w.elapsed_time = (w.state.time - min_time).to_i
              w.time = w.state.time
            else
              #w.elapsed_time = w.state.elapsed_time
              w.time = min_time + w.state.elapsed_time
            end
          }
        end
        min_time = wrappers.first&.time

        wrappers = wrappers.sort{|a,b| a.elapsed_time<=>b.elapsed_time}

        # day_offset
        t = wrappers.first&.time
        day_offset = 0
        if t
          day_offset = t - Time.mktime(t.year, t.month, t.day)
        end
        day_offset = (DAY - @date_line + day_offset) % DAY

        brew.states = wrappers
        brew.day_offset = day_offset
        brew.min_time = min_time
        if Moromi===brew
          brew.prefix_day_labels = @prefix_day_labels
        end
        brew
      end
    end
  end
end
