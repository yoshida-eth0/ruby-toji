module Toji
  module Progress
    module MotoState
      include BaseState

      KEYS = (BaseState::KEYS + [
        :baume,
        :acid,
        :warmings,
      ]).freeze

      # @dynamic baume
      # @dynamic acid

      # @dynamic warmings
    end
  end
end
