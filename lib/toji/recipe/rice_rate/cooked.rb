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


        DEFAULT = new(0.35, 0.5, 0.40, 0.36)

        @@rates = [
          #new(0.60, 0.380+0.1, 0.380),
          #new(0.55, 0.360+0.1, 0.360),
          #new(0.50, 0.335+0.1, 0.335),
          new(0.35, 0.5, 0.40, 0.36),
          new(0.33, 0.45, 0.40, 0.35),
        ]

        def self.soaked_rate(val)
          @@rates.select{|r| r.soaked_rate==val}.first
        end

        def self.before_steaming_rate(val)
          @@rates.select{|r| r.before_steaming_rate==val}.first
        end

        def self.steamed_rate(val)
          @@rates.select{|r| r.steamed_rate==val}.first
        end

        def self.cooled_rate(val)
          @@rates.select{|r| r.cooled_rate==val}.first
        end
      end


      def self.cooked(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
        Cooked.new(soaked_rate, before_steaming_rate, steamed_rate, cooled_rate)
      end
    end
  end
end
