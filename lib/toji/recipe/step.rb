module Toji
  module Recipe
    class Step
      attr_reader :rice
      attr_reader :koji
      attr_reader :water

      def initialize(rice, koji, water)
        @rice = Ingredient::Rice::Expected.create(rice)
        @koji = Ingredient::Koji::Expected.create(koji)
        @water = water.to_f
      end

      # 総米
      def rice_total
        @rice.raw + @koji.raw
      end

      # 総重量
      def weight_total
        @rice.cooled + @koji.dekoji + @water
      end

      # 麹歩合
      # 原料白米に占める麹米の割合
      # 留め仕込みまでの総米重量の20〜22%が標準である
      # なお、留め仕込みまでの麹歩合が20%を下回ると蒸米の溶解糖化に影響が出るので注意がいる
      # 出典: 酒造教本 P95
      def koji_rate
        @koji.raw / rice_total
      end

      # 汲水歩合
      #
      # 酒母: 110%が標準、高温糖化酒母は150〜180%
      # 添:   85〜100%の範囲で90%が標準、湧き進め型は歩合が高い
      # 仲:   120%が標準
      # 留:   130〜150%の範囲
      # 全体: 留までの総米に対し120〜130%、標準は125%、高級酒は130〜145%である
      #
      # 出典: 酒造教本 P96
      def water_rate
        @water / rice_total
      end

      def +(other)
        if Step===other
          self.class.new(@rice + other.rice, @koji + other.koji, @water + other.water)
        else
          x, y = other.coerce(self)
          x + y
        end
      end

      def *(other)
        if Integer===other || Float===other
          self.class.new(@rice * other, @koji * other, @water * other)
        else
          x, y = other.coerce(self)
          x * y
        end
      end
    end
  end
end
