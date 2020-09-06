module Toji
  module Product
    class Event
      attr_reader :date
      attr_reader :type

      def initialize(date, type)
        @date = date
        @type = type
      end
    end
  end
end
