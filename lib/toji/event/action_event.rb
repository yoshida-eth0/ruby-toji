require 'toji/event/base'

module Toji
  module Event
    module ActionEvent
      include Event

      attr_reader :index

    end
  end
end
