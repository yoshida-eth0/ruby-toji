require 'toji/product/event'

module Toji
  module Product
    class RiceEventGroup < Event
      attr_reader :breakdown

      def initialize(events)
        o = events.first
        super(o&.date, o&.type)
        @breakdown = events
      end

      def weight
        @breakdown.map(&:weight).sum
      end
    end
  end
end
