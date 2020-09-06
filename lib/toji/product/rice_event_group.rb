require 'toji/product/event'

module Toji
  module Product
    class RiceEventGroup < Event
      attr_reader :rice_type
      attr_reader :breakdown

      def initialize(events)
        o = events.first
        super(o&.date, :rice)
        @rice_type = o&.rice_type
        @breakdown = events
      end

      def weight
        @breakdown.map(&:weight).sum
      end
    end
  end
end
