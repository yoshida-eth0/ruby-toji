require 'toji/product/event'

module Toji
  module Product
    module RiceEventGroup
      include Event

      attr_reader :rice_type
      attr_reader :breakdown

      def type
        :rice
      end

      def weight
        breakdown.map(&:weight).sum
      end
    end
  end
end
