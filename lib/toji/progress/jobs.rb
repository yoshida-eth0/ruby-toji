module Toji
  module Progress
    class Jobs
      include Enumerable

      def initialize(arr)
        @arr = arr.clone

        @hash = {}
        arr.select {|j| j.id}.each {|j|
          @hash[j.id] = j
        }
      end

      def [](id)
        @hash[id]
      end

      def []=(id, job)
        if @hash[id]
          @arr.delete(@hash[id])
        end
        @hash[id] = job
        @arr << job
      end

      def each(&block)
        @arr.sort{|a,b| a.elapsed_time<=>b.elapsed_time}.each(&block)
      end
    end
  end
end
