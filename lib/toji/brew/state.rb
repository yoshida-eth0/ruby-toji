module Toji
  module Brew
    module BaseState
      REQUIRED_KEYS = [
        :time,
        :elapsed_time,
        :day,
        :day_label,
        :display_time,
        :mark,
      ].freeze

      attr_accessor :progress

      attr_accessor :time
      attr_accessor :mark

      def elapsed_time
        time - progress.base_time
      end

      def elapsed_time_with_offset
        elapsed_time + progress.day_offset
      end

      def day
        ((elapsed_time_with_offset.to_f + 1) / DAY).ceil
      end

      def day_label
        progress.day_labels[day - 1]
      end

      def display_time(format="%m/%d %H:%M")
        time.strftime(format)
      end
    end
  end
end

module Toji
  module Brew
    module KojiState
      include BaseState

      OPTIONAL_KEYS = [
        :temps,
        :preset_temp,
        :room_temp,
        :room_psychrometry,

        :note,
      ].freeze

      attr_accessor :temps
      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry

      attr_accessor :note
    end
  end
end

module Toji
  module Brew
    module MotoState
      include BaseState

      OPTIONAL_KEYS = [
        :temps,
        :preset_temp,
        :room_temp,
        :room_psychrometry,

        :baume,
        :acid,

        :warmings,
        :note,
      ].freeze

      attr_accessor :temps
      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry

      attr_accessor :baume
      attr_accessor :acid

      attr_accessor :warmings
      attr_accessor :note
    end
  end
end

module Toji
  module Brew
    module MoromiState
      include BaseState

      OPTIONAL_KEYS = [
        :moromi_day,
        :temps,
        :preset_temp,
        :room_temp,
        :room_psychrometry,

        :baume,
        :nihonshudo,
        :display_baume,
        :acid,
        :amino_acid,
        :alcohol,
        :bmd,

        :warmings,
        :note,
      ].freeze

      attr_accessor :temps
      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry

      attr_accessor :baume
      attr_accessor :nihonshudo
      attr_accessor :acid
      attr_accessor :amino_acid
      attr_accessor :alcohol

      attr_accessor :warmings
      attr_accessor :note

      def moromi_day
        _tome_day = progress.moromi_tome_day
        _now_day = day

        if _tome_day && _tome_day < _now_day
          _now_day - _tome_day + 1
        end
      end

      def display_baume
        _baume = baume
        if _baume
          if _baume<3.0
            nihonshudo
          else
            _baume
          end
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


      module BaumeToNihonshudo
        def nihonshudo
          if self.baume
            self.baume * -10
          end
        end

        def nihonshudo=(val)
          if val
            self.baume = val.to_f / -10.0
          else
            self.baume = nil
          end
        end
      end

      module NihonshudoToBaume
        def baume
          if self.nihonshudo
            self.nihonshudo / -10.0
          end
        end

        def baume=(val)
          if val
            self.nihonshudo = val.to_f * -10
          else
            self.nihonshudo = nil
          end
        end
      end
    end
  end
end
