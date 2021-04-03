module Toji
  module Progress
    module MoromiState
      include BaseState

      KEYS = (BaseState::KEYS + [
        :moromi_day,
        :baume,
        :nihonshudo,
        :display_baume,
        :acid,
        :amino_acid,
        :alcohol,
        :bmd,
        :glucose,
        :warmings,
      ]).freeze

      # @dynamic baume
      # @dynamic nihonshudo
      # @dynamic acid
      # @dynamic amino_acid
      # @dynamic alcohol
      # @dynamic glucose
      # @dynamic warmings

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
