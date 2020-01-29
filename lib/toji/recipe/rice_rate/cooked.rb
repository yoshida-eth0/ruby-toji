module Toji
  module Recipe
    module RiceRate
      class Cooked
        include Base

        # 炊飯器を使う場合
        #
        # 浸漬。
        # 25〜30分くらい浸漬させないと中心部まで水を吸わない。
        #  => 吸水歩合 約1.30。
        #
        # 炊飯。
        # 吸水と炊く用の水を合わせて歩合1.50くらいにしないと中心部まで火が通らない、且つ側面が焦げる。
        # 圧力がかかる熟成炊きみたいな長めの炊飯が良い。
        #  => 蒸米歩合 約1.40。
        #
        # 白米の60%の水で炊くと蒸米吸水率はだいたい38%くらいになる
        # 炊飯、放冷の過程で水分のうち36%程度は蒸発する
        #
        # 放冷。
        # 歩合1.36〜1.37くらいになる。
        # 更に歩合を下げたければ炊飯までは同じで、放冷に注力するのが良い。

        # 重量推移の例
        #
        # 浸漬
        #  before
        #   白米(無洗米コシヒカリ) 100g
        #  after
        #   吸水後白米 130g
        #   (吸水歩合 30%)
        #
        # 炊飯
        #  before
        #   吸水後白米 130g
        #   炊飯用水 20g
        #   (吸水歩合＋炊飯水率 50%)
        #  after
        #   炊飯米 140g
        #   (炊飯米吸水率 40%)
        #
        # 放冷
        #  before
        #   炊飯米 140g
        #  after
        #   放冷後炊飯米 136g
        #   (放冷後炊飯米吸水率 36%)

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
