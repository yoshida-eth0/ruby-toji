module Toji
  module Brew
    class Builder

      def initialize(progress_cls, state_cls)
        @progress_cls = progress_cls
        @state_cls = state_cls
        @states = []
        @date_line = 0
        @prefix_day_labels = nil
        @base_time = nil
        @time_interpolation = false
        @elapsed_time_interpolation = false
      end

      def <<(state)
        @states += [state].flatten.map {|state|
          if State===state
            state
          else
            @state_cls.create(state)
          end
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

      def time_interpolation(base_time)
        @base_time = base_time&.to_time
        @time_interpolation = true
        #@elapsed_time_interpolation = false
        self
      end

      def elapsed_time_interpolation
        #@base_time = nil
        #@time_interpolation = false
        @elapsed_time_interpolation = true
        self
      end

      def build
        progress = @progress_cls.new

        states = @states.map{|s|
          s.progress = progress
          s
        }

        ## time interpolation
        #if @time_interpolation
        #  base_time = @base_time

        #  base_state = @states.select{|w| w.time && w.elapsed_time}.first
        #  if base_state
        #    base_time = base_state.time - base_state.elapsed_time
        #  end

        #  @states.each {|w|
        #    if w.elapsed_time
        #      w.time = base_time + w.elapsed_time
        #    end
        #  }
        #end

        ## elapsed_time interpolation
        #if @elapsed_time_interpolation
        #  base_time = @states.map(&:time).sort.first
        #  @states.each {|w|
        #    if w.time
        #      w.elapsed_time = (w.time - base_time).to_i
        #    end
        #  }
        #end

        ##@states = @states.sort_by(&:elapsed_time)
        #base_time = @states.first&.time

        ## day_offset
        #day_offset = 0
        #if base_time
        #  day_offset = base_time - Time.mktime(base_time.year, base_time.month, base_time.day)
        #end
        #day_offset = (DAY - @date_line + day_offset) % DAY

        progress.states = states
        #progress.day_offset = day_offset
        #progress.base_time = base_time
        if MoromiProgress===progress
          progress.prefix_day_labels = @prefix_day_labels
        end
        progress
      end
    end
  end
end
