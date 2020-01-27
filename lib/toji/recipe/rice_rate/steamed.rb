module Toji
  module Recipe
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
      end


      def self.steamed(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
        Steamed.new(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
      end
    end
  end
end
