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
    end
  end
end
