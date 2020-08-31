module Toji
  module Brew
    class Builder

      def initialize(cls)
        @cls = cls
        @states = []
        @date_line = 0
        @prefix_day_labels = nil
        @ab_coef = 0.0
        @base_time = nil
        @time_interpolation = false
        @elapsed_time_interpolation = false
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

      def ab_coef(val)
        @ab_coef = val
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
        brew = @cls.new

        wrapped_states = @states.map{|s| WrappedState.new(s, brew)}

        # time interpolation
        if @time_interpolation
          base_time = @base_time

          base_state = wrapped_states.select{|w| w.time && w.elapsed_time}.first
          if base_state
            base_time = base_state.time - base_state.elapsed_time
          end

          wrapped_states.each {|w|
            if w.elapsed_time
              w.time = base_time + w.elapsed_time
            end
          }
        end

        # elapsed_time interpolation
        if @elapsed_time_interpolation
          base_time = wrapped_states.map(&:time).sort.first
          wrapped_states.each {|w|
            if w.time
              w.elapsed_time = (w.time - base_time).to_i
            end
          }
        end

        wrapped_states = wrapped_states.sort_by(&:elapsed_time)
        base_time = wrapped_states.first&.time

        # day_offset
        day_offset = 0
        if base_time
          day_offset = base_time - Time.mktime(base_time.year, base_time.month, base_time.day)
        end
        day_offset = (DAY - @date_line + day_offset) % DAY

        brew.wrapped_states = wrapped_states
        brew.day_offset = day_offset
        brew.base_time = base_time
        if Moromi===brew
          brew.prefix_day_labels = @prefix_day_labels
          brew.ab_coef = @ab_coef
        end
        brew
      end
    end
  end
end
