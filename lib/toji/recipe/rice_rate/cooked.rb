module Toji
  module Recipe
    module RiceRate
      class Cooked
        include Base

        # 炊飯器を使う場合
        # 白米の60%の水で炊くと蒸米吸水率はだいたい38%くらいになる
        # 炊飯、放冷の過程で水分のうち36%程度は蒸発する

        # 蒸す前
        # ・白米(無洗米コシヒカリ) 85g
        # ・水 50g
        # ・浸漬米吸水率 58.82%
        # 
        # 蒸した後
        # ・蒸米 117.5g
        # ・蒸米吸水率 38.24%

        def initialize(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
          @soaked_rate = soaked_rate
          @before_steaming_rate = before_steaming_rate
          @steamed_rate = steamed_rate
          @cooled_rate = cooled_rate
        end


        DEFAULT = new(0.30, 0.5, 0.40, 0.36)
      end


      def self.cooked(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
        Cooked.new(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
      end
    end
  end
end
