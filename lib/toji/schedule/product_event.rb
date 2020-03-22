module Toji
  module Schedule
    class ProductEvent
      attr_reader :product
      attr_reader :type
      attr_reader :index
      
      def initialize(product, type, index)
        @product = product
        @type = type
        @index = index
      end

      def date
        method = "#{@type}_dates".to_sym
        @product.send(method)[@index]
      end

      def group_index
        method = "#{@type}_dates".to_sym
        dates = @product.send(method)
        date = dates[@index]
        dates.index(date)
      end

      def group_key
        a = []
        a << product.name
        a << type
        a << group_index
        a.map(&:to_s).join(":")
      end

      def weight
        @product.recipe.steps[@index].send(@type).raw
      end
    end
  end
end
