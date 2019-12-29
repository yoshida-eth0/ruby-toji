module Toji
  module Progress
    class Job
      HOUR = 60 * 60
      DAY = 24 * HOUR

      attr_reader :time
      attr_reader :elapsed_time
      attr_reader :id
      attr_reader :before_temp
      attr_reader :after_temp
      attr_reader :room_temp
      attr_reader :room_hum
      attr_reader :note

      def initialize(time: nil, elapsed_time: nil, id: nil, before_temp: nil, after_temp: nil, room_temp: nil, room_hum: nil, note: nil)
        @time = time
        @elapsed_time = elapsed_time
        @id = id
        @before_temp = before_temp
        @after_temp = after_temp
        @room_temp = room_temp
        @room_hum = room_hum
        @note = note
      end
    end
  end
end
