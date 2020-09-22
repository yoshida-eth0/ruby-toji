require 'toji/product/event'

module Toji
  module Product
    module RiceEvent
      include Event

      attr_reader :product
      attr_reader :rice_type
      attr_reader :index
      attr_reader :group_index
      attr_reader :weight
      
      def type
        :rice
      end

      def group_key
        a = []
        a << product.reduce_key
        a << rice_type
        a << group_index
        a.map(&:to_s).join(":")
      end
    end
  end
end
