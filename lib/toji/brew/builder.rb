module Toji
  module Brew
    class Builder

      def initialize(progress_cls, state_cls)
        @progress_cls = progress_cls
        @state_cls = state_cls
        @states = []
        @date_line = 0
        @prefix_day_labels = nil
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

      def build
        progress = @progress_cls.new

        states = @states.map{|s|
          s.progress = progress
          s
        }.sort_by(&:time)

        progress.states = states
        progress.date_line = @date_line
        if progress.respond_to?(:prefix_day_labels=)
          progress.prefix_day_labels = @prefix_day_labels
        end

        progress
      end
    end
  end
end
