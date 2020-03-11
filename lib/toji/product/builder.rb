module Toji
  module Product
    class Builder

      def initialize(cls)
        @cls = cls
        @records = []
        @date_line = 0
      end

      def <<(record)
        @records += [record].flatten
        self
      end
      alias_method :add, :<<

      def date_line(val)
        @date_line = val
        self
      end

      def build
        data = Data.new(@records, @date_line)
        @cls.new(data)
      end
    end
  end
end
