require 'toji/product/event'

module Toji
  module Product
    module ActionEvent
      include Event

      attr_reader :product
      attr_reader :index

    end
  end
end
