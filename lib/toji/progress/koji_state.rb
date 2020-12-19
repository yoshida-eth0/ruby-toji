module Toji
  module Progress
    module KojiState
      include BaseState

      OPTIONAL_KEYS = [
        :temps,
        :preset_temp,
        :room_temp,
        :room_psychrometry,

        :note,
      ].freeze

      # @dynamic temps
      # @dynamic preset_temp
      # @dynamic room_temp
      # @dynamic room_psychrometry

      # @dynamic note
    end
  end
end
