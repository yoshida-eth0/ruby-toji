require 'toji/event/rice_event'

module Toji
  module Event
    module KojiEvent
      include RiceEvent

      attr_reader :dekoji

      def rice_type
        :koji
      end

      def dekoji_ratio
        (dekoji.to_f - weight.to_f) / weight.to_f
      end
    end
  end
end
