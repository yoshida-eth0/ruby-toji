module Toji
  module Material
    module Yeast
      module Base
        # 1リットル醸造のために必要な酵母の量
        attr_reader :yeast_rate

        # 乾燥酵母を戻すのに必要な水の量
        attr_reader :water_rate

        def yeast
          @total * yeast_rate / 1000.0
        end

        def water
          yeast * water_rate
        end
      end
    end
  end
end
