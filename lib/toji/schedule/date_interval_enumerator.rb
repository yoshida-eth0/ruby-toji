module Toji
  module Schedule
    class DateIntervalEnumerator
      include Enumerable

      def initialize(intervals, afterwards)
        @intervals = intervals
        @afterwards = afterwards
      end

      def each(&block)
        Enumerator.new do |y|
          y << 0
          @intervals.each {|interval|
            y << interval
          }
          loop {
            y << @afterwards
          }
        end.each(&block)
      end

      def merge(dates, length)
        dates = [dates].flatten
        enum = each

        length.times {|i|
          add = enum.next

          if i==0
            dates[i] = dates[i].to_time
          elsif Integer===dates[i] && dates[i-1]
            dates[i] = dates[i-1].since(dates[i].days)
          elsif !dates[i] && dates[i-1]
            dates[i] = dates[i-1].since(add.days)
          else
            dates[i] = dates[i].to_time
          end
        }

        dates
      end
    end
  end
end
