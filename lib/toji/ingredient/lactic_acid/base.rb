module Toji
  module Ingredient
    module LacticAcid
      module Base
        attr_reader :moto_rate
        attr_reader :soe_rate

        def moto
          @total * moto_rate
        end

        def soe
          @total * soe_rate
        end
      end
    end
  end
end
