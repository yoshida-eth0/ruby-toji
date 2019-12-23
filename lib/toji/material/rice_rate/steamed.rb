module Toji
  module Material
    module RiceRate
      class Steamed
        include Base

        def initialize(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
          @soaked_rate = soaked_rate
          @before_steaming_rate = before_steaming_rate
          @steamed_rate = steamed_rate
          @cooled_rate = cooled_rate
        end

        def before_steaming_rate
          @before_steaming_rate || begin
            @soaked_rate - 0.04
          end
        end


        DEFAULT = new(0.33, nil, 0.41, 0.33)

        def self.soaked_rate(val)
          @@rates.select{|r| r.soaked_rate==val}.first
        end

        def self.steamed_rate(val)
          @@rates.select{|r| r.steamed_rate==val}.first
        end

        def self.cooled_rate(val)
          @@rates.select{|r| r.cooled_rate==val}.first
        end
      end

      def self.steamed(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
        Steamed.new(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
      end
    end
  end
end
