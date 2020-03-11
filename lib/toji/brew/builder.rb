module Toji
  module Brew
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
        @cls.new(@records, @date_line)
      end
    end
  end
end
