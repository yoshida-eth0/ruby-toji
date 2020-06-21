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
        [kake, koji].compact.map(&:to_f).sum
      end

      # 麹歩合
      # 原料白米に占める麹米の割合
      # 留め仕込みまでの総米重量の20〜22%が標準である
      # なお、留め仕込みまでの麹歩合が20%を下回ると蒸米の溶解糖化に影響が出るので注意がいる
      # 出典: 酒造教本 P95
      def koji_rate
        (koji || 0.0) / rice_total
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
        (water || 0.0) / rice_total
      end

      def round(ndigit=0, mini_ndigit=nil, half: :up)
        if !mini_ndigit
          mini_ndigit = ndigit + 3
        end

        self.class.new.tap {|o|
          o.name = name
          o.kake = kake.round(ndigit, half: half)
          o.koji = koji.round(ndigit, half: half)
          o.water = water.round(ndigit, half: half)
          o.lactic_acid = lactic_acid.round(mini_ndigit, half: half)
          o.alcohol = alcohol.round(ndigit, half: half)
          o.yeast = yeast.round(mini_ndigit, half: half)
          o.koji_interval_days = koji_interval_days
          o.kake_interval_days = kake_interval_days
        }
      end

      def +(other)
        if Step===other
          self.class.new.tap {|o|
            o.name = name
            o.kake = kake + other.kake
            o.koji = koji + other.koji
            o.water = water + other.water
            o.lactic_acid = lactic_acid + other.lactic_acid
            o.alcohol = alcohol + other.alcohol
            o.yeast = yeast + other.yeast
            o.koji_interval_days = koji_interval_days
            o.kake_interval_days = kake_interval_days
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
            o.kake = kake * other
            o.koji = koji * other
            o.water = water * other
            o.lactic_acid = lactic_acid * other
            o.alcohol = alcohol * other
            o.yeast = yeast * other
            o.koji_interval_days = koji_interval_days
            o.kake_interval_days = kake_interval_days
          }
        else
          x, y = other.coerce(self)
          x * y
        end
      end
    end
  end
end
