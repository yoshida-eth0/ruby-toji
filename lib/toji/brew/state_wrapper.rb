require 'forwardable'

module Toji
  module Brew
    class StateWrapper
      extend Forwardable

      attr_accessor :elapsed_time
      attr_accessor :time
      attr_reader :state
      attr_reader :brew

      def_delegators :@state, :mark
      def_delegators :@state, :temps
      def_delegators :@state, :preset_temp
      def_delegators :@state, :room_temp
      def_delegators :@state, :room_psychrometry
      def_delegators :@state, :acid
      def_delegators :@state, :amino_acid
      def_delegators :@state, :alcohol
      def_delegators :@state, :warmings
      def_delegators :@state, :note

      def initialize(elapsed_time, state, brew)
        @elapsed_time = elapsed_time
        @state = state
        @brew = brew
      end

      def day
        ((elapsed_time_with_offset.to_f + 1) / DAY).ceil
      end

      def day_label
        @brew.day_labels[day - 1]
      end

      def elapsed_time_with_offset
        @elapsed_time + @brew.day_offset
      end

      def baume
        if @state.baume
          @state.baume
        elsif @state.nihonshudo
          @state.nihonshudo * -0.1
        end
      end

      def nihonshudo
        if @state.nihonshudo
          @state.nihonshudo
        elsif @state.baume
          @state.baume * -10
        end
      end

      def display_baume
        if @state.baume || @state.nihonshudo
          b = baume
          if b<3.0
            nihonshudo
          else
            b
          end
        end
      end

      def display_time(format="%m/%d %H:%M")
        if @time
          @time.strftime(format)
        elsif @brew.min_time
          time = @brew.min_time + @elapsed_time
          time.strftime(format)
        else
          utc_offset = Time.at(0).utc_offset
          Time.at(@elapsed_time - utc_offset).strftime(format)
        end
      end

      def moromi_day
        _tome_day = @brew.moromi_tome_day
        _now_day = day

        if _tome_day && _tome_day < _now_day
          _now_day - _tome_day + 1
        end
      end

      def bmd
        _moromi_day = moromi_day
        _baume = baume

        if _moromi_day && _baume
          _moromi_day * _baume
        end
      end

      def expected_alcohol(target_alc, target_nihonshudo, coef)
        _baume = baume

        if _baume
          target_alc - (_baume - target_nihonshudo * -0.1) * coef
        end
      end

      def to_h
        {
          elapsed_time: elapsed_time,
          time: time,
          mark: mark,
          temps: temps,
          preset_temp: preset_temp,
          room_temp: room_temp,
          room_psychrometry: room_psychrometry,
          acid: acid,
          amino_acid: amino_acid,
          alcohol: alcohol,
          warmings: warmings,
          note: note,

          day: day,
          day_label: day_label,
          elapsed_time_with_offset: elapsed_time_with_offset,
          baume: baume,
          nihonshudo: nihonshudo,
          display_baume: display_baume,
          display_time: display_time,
          moromi_day: moromi_day,
          bmd: bmd,
        }
      end
    end
  end
end
