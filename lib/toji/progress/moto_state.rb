module Toji
  module Progress
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

      # @dynamic temps
      # @dynamic preset_temp
      # @dynamic room_temp
      # @dynamic room_psychrometry

      # @dynamic baume
      # @dynamic acid

      # @dynamic warmings
      # @dynamic note
    end
  end
end
