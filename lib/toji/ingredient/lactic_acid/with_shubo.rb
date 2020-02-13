module Toji
  module Ingredient
    module LacticAcid
      class WithShubo
        include Base

        def initialize(total)
          @total = total
          @moto_rate = 0.0069
          @soe_rate = 0.0
        end
      end
    end
  end
end
