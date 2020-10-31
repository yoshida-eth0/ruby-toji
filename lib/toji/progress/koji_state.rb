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

      attr_accessor :temps
      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry

      attr_accessor :note
    end
  end
end
