module Toji
  module Ingredient
    module LacticAcid
      class Kimoto
        include Base

        def initialize(total)
          @total = total
          @moto_rate = 0.0
          @soe_rate = 0.0
        end
      end
    end
  end
end
