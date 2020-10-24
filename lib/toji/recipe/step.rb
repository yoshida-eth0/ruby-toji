module Toji
  module Recipe
    module Step
      attr_accessor :koji
      attr_accessor :kake
      attr_accessor :water
      attr_accessor :lactic_acid
      attr_accessor :alcohol
      attr_accessor :yeast

      # 総米
      def rice_total
        kake&.weight.to_f + koji&.weight.to_f
      end

      # 麹歩合
      # 原料白米に占める麹米の割合
      # 留め仕込みまでの総米重量の20〜22%が標準である
      # なお、留め仕込みまでの麹歩合が20%を下回ると蒸米の溶解糖化に影響が出るので注意がいる
      # 出典: 酒造教本 P95
      def koji_ratio
        val = koji&.weight.to_f / rice_total
        val.nan? ? 0.0 : val
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
      def water_ratio
        val = water&.weight.to_f / rice_total
        val.nan? ? 0.0 : val
      end

      def round!(ndigit=0, mini_ndigit=nil, half: :up)
        if !mini_ndigit
          mini_ndigit = ndigit + 3
        end

        if koji
          self.koji.weight = koji.weight.to_f.round(ndigit, half: half)
        end
        if kake
          self.kake.weight = kake.weight.to_f.round(ndigit, half: half)
        end
        if water
          self.water.weight = water.weight.to_f.round(ndigit, half: half)
        end
        if lactic_acid
          self.lactic_acid.weight = lactic_acid.weight.to_f.round(mini_ndigit, half: half)
        end
        if alcohol
          self.alcohol.weight = alcohol.weight.to_f.round(ndigit, half: half)
        end
        if yeast
          self.yeast.weight = yeast.weight.to_f.round(mini_ndigit, half: half)
        end

        self
      end

      def round(ndigit=0, mini_ndigit=nil, half: :up)
        Utils.check_dup(self)

        dst = self.dup
        dst.round!(ndigit, mini_ndigit, half: half)
      end

      def +(other)
        if Step===other
          Utils.check_dup(self)

          # CAUTION: dst.xxxがnilだった場合、dst.xxxはnilのままになる
          dst = self.dup
          dst.koji&.weight += other.koji&.weight || 0
          dst.kake&.weight += other.kake&.weight || 0
          dst.water&.weight += other.water&.weight || 0
          dst.lactic_acid&.weight += other.lactic_acid&.weight || 0
          dst.alcohol&.weight += other.alcohol&.weight || 0
          dst.yeast&.weight += other.yeast&.weight || 0
          dst
        else
          x, y = other.coerce(self)
          x + y
        end
      end

      def *(other)
        if Integer===other || Float===other
          Utils.check_dup(self)

          dst = self.dup
          dst.koji&.weight *= other
          dst.kake&.weight *= other
          dst.water&.weight *= other
          dst.lactic_acid&.weight *= other
          dst.alcohol&.weight *= other
          dst.yeast&.weight *= other
          dst
        else
          x, y = other.coerce(self)
          x * y
        end
      end
    end
  end
end
