require 'toji/event/rice_event'

module Toji
  module Event
    module KojiEvent
      include RiceEvent

      attr_reader :dekoji

      def rice_type
        :koji
      end

      def dekoji_rate
        (dekoji.to_f - raw.to_f) / raw.to_f
      end
    end
  end
end
