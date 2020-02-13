module Toji
  module Ingredient
    module LacticAcid
      class WithoutShubo
        include Base

        def initialize(total)
          @total = total
          @moto_rate = 0.006
          @soe_rate = 0.002
        end
      end
    end
  end
end
