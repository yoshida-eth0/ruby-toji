require 'toji/product/state_accessor'
require 'toji/product/data'
require 'toji/product/state'
require 'toji/product/state_record'
require 'toji/product/builder'

module Toji
  module Product

    HOUR = 60 * 60
    DAY = 24 * HOUR

    WARM_DAKI = 1
    WARM_ANKA = 1<<1
    WARM_MAT = 1<<2

    attr_reader :data

    def data=(data)
      @data = data
      @data.day_labels = day_labels
    end

    def day_labels
      @data.days.times.map(&:succ)
    end

    def self.included(cls)
      cls.extend ClassMethods
    end

    module ClassMethods
      include StateAccessor

      def create(data, date_line: 0)
        if Product===data
          data
        else
          builder.add(data).date_line(date_line).build
        end
      end

      def builder
        Builder.new(self)
      end
    end
  end
end
