require 'forwardable'

module Toji
  module Product
    class State
      extend Forwardable

      attr_accessor :elapsed_time
      attr_accessor :time
      attr_accessor :day_label
      attr_reader :record
      attr_reader :data

      def_delegators :@record, :mark
      def_delegators :@record, :temps
      def_delegators :@record, :preset_temp
      def_delegators :@record, :room_temp
      def_delegators :@record, :room_psychrometry
      def_delegators :@record, :acid
      def_delegators :@record, :amino_acid
      def_delegators :@record, :alcohol
      def_delegators :@record, :warming
      def_delegators :@record, :note

      def_delegators :@record, :has_keys

      def initialize(elapsed_time, record, data)
        @elapsed_time = elapsed_time
        @record = record
        @data = data
      end

      def day
        ((elapsed_time_with_offset.to_f + 1) / DAY).ceil
      end

      def day_label
        @data.day_labels[day - 1]
      end

      def elapsed_time_with_offset
        @elapsed_time + @data.day_offset
      end

      def baume
        if @record.baume
          @record.baume
        elsif @record.nihonshudo
          @record.nihonshudo * -0.1
        end
      end

      def nihonshudo
        if @record.nihonshudo
          @record.nihonshudo
        elsif @record.baume
          @record.baume * -10
        end
      end

      def display_baume
        if @record.baume || @record.nihonshudo
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
        else
          Time.at(@elapsed_time).strftime(format)
        end
      end

      def moromi_day
        _start_day = @data.moromi_start_day
        _now_day = day

        if _start_day && _start_day < _now_day
          _now_day - _start_day + 1
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
    end
  end
end
