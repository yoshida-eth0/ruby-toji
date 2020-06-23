module Toji
  module Recipe
    module Step
      attr_accessor :name
      attr_accessor :kake
      attr_accessor :koji
      attr_accessor :water
      attr_accessor :lactic_acid
      attr_accessor :alcohol
      attr_accessor :yeast
      attr_accessor :koji_interval_days
      attr_accessor :kake_interval_days

      # 総米
      def rice_total
        kake.to_f + koji.to_f
      end

      # 麹歩合
      # 原料白米に占める麹米の割合
      # 留め仕込みまでの総米重量の20〜22%が標準である
      # なお、留め仕込みまでの麹歩合が20%を下回ると蒸米の溶解糖化に影響が出るので注意がいる
      # 出典: 酒造教本 P95
      def koji_rate
        val = koji.to_f / rice_total
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
      def water_rate
        val = water.to_f / rice_total
        val.nan? ? 0.0 : val
      end

      def round(ndigit=0, mini_ndigit=nil, half: :up)
        if !mini_ndigit
          mini_ndigit = ndigit + 3
        end

        self.class.new.tap {|o|
          o.name = name
          o.kake = kake.to_f.round(ndigit, half: half)
          o.koji = koji.to_f.round(ndigit, half: half)
          o.water = water.to_f.round(ndigit, half: half)
          o.lactic_acid = lactic_acid.to_f.round(mini_ndigit, half: half)
          o.alcohol = alcohol.to_f.round(ndigit, half: half)
          o.yeast = yeast.to_f.round(mini_ndigit, half: half)
          o.koji_interval_days = koji_interval_days.to_i
          o.kake_interval_days = kake_interval_days.to_i
        }
      end

      def +(other)
        if Step===other
          self.class.new.tap {|o|
            o.name = name
            o.kake = kake.to_f + other.kake.to_f
            o.koji = koji.to_f + other.koji.to_f
            o.water = water.to_f + other.water.to_f
            o.lactic_acid = lactic_acid.to_f + other.lactic_acid.to_f
            o.alcohol = alcohol.to_f + other.alcohol.to_f
            o.yeast = yeast.to_f + other.yeast.to_f
            o.koji_interval_days = koji_interval_days.to_i
            o.kake_interval_days = kake_interval_days.to_i
          }
        else
          x, y = other.coerce(self)
          x + y
        end
      end

      def *(other)
        if Integer===other || Float===other
          self.class.new.tap {|o|
            o.name = name
            o.kake = kake.to_f * other
            o.koji = koji.to_f * other
            o.water = water.to_f * other
            o.lactic_acid = lactic_acid.to_f * other
            o.alcohol = alcohol.to_f * other
            o.yeast = yeast.to_f * other
            o.koji_interval_days = koji_interval_days.to_i
            o.kake_interval_days = kake_interval_days.to_i
          }
        else
          x, y = other.coerce(self)
          x * y
        end
      end
    end
  end
end
