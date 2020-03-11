module Toji
  module Product
    class Data
      include Enumerable

      def initialize(records, date_line)
        @date_line = date_line
        self.records = records
      end

      def records=(records)
        records = records.map{|r| StateRecord.create(r)}
        min_time = records.select{|j| j.time}.map(&:time).sort.first
        @states = records.map{|j| State.new(j.elapsed_time, j, self)}

        # time
        if min_time
          @states.each {|s|
            if s.record.time
              s.elapsed_time = (s.record.time - min_time).to_i
              s.time = s.record.time
            else
              #s.elapsed_time = s.record.elapsed_time
              s.time = min_time + s.record.elapsed_time
            end
          }
        end

        @states = @states.sort{|a,b| a.elapsed_time<=>b.elapsed_time}

        # day_offset
        t = @states.first&.time
        day_offset = 0
        if t
          day_offset = t - Time.mktime(t.year, t.month, t.day)
        end
        day_offset += ((24 - @date_line) % 24) * HOUR

        @states.each {|s|
          s.day_offset = day_offset
        }

        # day_label
        @states.each {|s|
          s.day_label = s.day + 1
        }

        # mark hash
        @hash = {}
        @states.select{|s| s.record.mark}.each {|s|
          @hash[s.record.mark] = s
        }
      end

      def days
        ((@states.last.elapsed_time_with_offset.to_f + 1) / DAY).ceil
      end

      def day_labels=(day_labels)
        @states.each {|s|
          s.day_label = day_labels[s.day - 1]
        }
      end

      def [](mark)
        @hash[mark]
      end

      def states
        @states.clone.freeze
      end

      def each(&block)
        @states.each(&block)
      end
    end
  end
end
