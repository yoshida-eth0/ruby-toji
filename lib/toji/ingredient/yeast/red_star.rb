module Toji
  module Ingredient
    module Yeast
      # RedStar酵母
      #
      # 容量        5g
      # 醸造可能量  20〜23L
      #
      # ドライイーストは、生イーストの保存性を高めるために、その水分を大部分除いたものです。
      # 使用時にはイーストの10倍以上の30-35℃の無菌のお湯（ミネラルウオーターや湯冷まし）で20-25分程度なじませてください。
      # これにより水分を再吸収させると同 時に発酵力を回復させ、生イーストの状態にもどします。
      # このときの温湯の温度が、イーストの発酵力に影響します
      class RedStar
        include Base

        def initialize(total)
          @total = total
          @yeast_rate = 5.0 / 20.0
          @water_rate = 10.0
        end
      end
    end
  end
end
