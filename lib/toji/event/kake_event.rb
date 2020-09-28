require 'toji/event/rice_event'

module Toji
  module Event
    module KakeEvent
      include RiceEvent

      def rice_type
        :kake
      end
    end
  end
end
