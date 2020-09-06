require 'toji/product/event'

module Toji
  module Product
    class RiceEvent < Event
      attr_reader :product
      attr_reader :index
      attr_reader :group_index
      attr_reader :weight
      
      def initialize(product:, type:, index:, group_index:, date:, weight:)
        super(date, type)
        @product = product
        @index = index
        @group_index = group_index
        @weight = weight
      end

      def group_key
        a = []
        a << product.reduce_key
        a << type
        a << group_index
        a.map(&:to_s).join(":")
      end
    end
  end
end
