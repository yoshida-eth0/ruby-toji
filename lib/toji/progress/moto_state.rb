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
