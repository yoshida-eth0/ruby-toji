module Toji
  class Recipe
    class Step
      attr_reader :name
      attr_reader :kake
      attr_reader :koji
      attr_reader :water
      attr_reader :lactic_acid
      attr_reader :alcohol
      attr_reader :yeast
      attr_reader :koji_interval_days
      attr_reader :kake_interval_days

      def initialize(name:, kake: 0, koji: 0, water: 0, lactic_acid: 0, alcohol: 0, yeast: 0, koji_interval_days: 0, kake_interval_days: 0)
        @name = name
        @kake = Ingredient::Kake::Expected.create(kake)
        @koji = Ingredient::Koji::Expected.create(koji)
        @water = water.to_f
        @lactic_acid = lactic_acid.to_f
        @alcohol = alcohol.to_f
        @yeast = yeast.to_f
        @koji_interval_days = koji_interval_days.to_i
        @kake_interval_days = kake_interval_days.to_i
      end

      # 総米
      def rice_total
        @kake.raw + @koji.raw
      end

      # 総重量
      def weight_total
        @kake.cooled + @koji.dekoji + @water + @lactic_acid + @alcohol + @yeast
      end

      # 麹歩合
      # 原料白米に占める麹米の割合
      # 留め仕込みまでの総米重量の20〜22%が標準である
      # なお、留め仕込みまでの麹歩合が20%を下回ると蒸米の溶解糖化に影響が出るので注意がいる
      # 出典: 酒造教本 P95
      def koji_rate
        ret = @koji.raw / rice_total
        ret.nan? ? 0.0 : ret
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
        ret = @water / rice_total
        ret.nan? ? 0.0 : ret
      end

      def round(ndigit=0, acid_ndigit=nil, half: :up)
        if !acid_ndigit
          acid_ndigit = ndigit + 3
        end

        self.class.new(
          name: @name,
          kake: @kake.round(ndigit, half: half),
          koji: @koji.round(ndigit, half: half),
          water: @water.round(ndigit, half: half),
          lactic_acid: @lactic_acid.round(acid_ndigit, half: half),
          alcohol: @alcohol.round(ndigit, half: half),
          yeast: @yeast.round(ndigit, half: half),
          koji_interval_days: koji_interval_days,
          kake_interval_days: kake_interval_days,
        )
      end

      def +(other)
        if Step===other
          self.class.new(
            name: nil,
            kake: @kake + other.kake,
            koji: @koji + other.koji,
            water: @water + other.water,
            lactic_acid: @lactic_acid + other.lactic_acid,
            alcohol: @alcohol + other.alcohol,
            yeast: @yeast + other.yeast,
            koji_interval_days: koji_interval_days,
            kake_interval_days: kake_interval_days,
          )
        else
          x, y = other.coerce(self)
          x + y
        end
      end

      def *(other)
        if Integer===other || Float===other
          self.class.new(
            name: @name,
            kake: @kake * other,
            koji: @koji * other,
            water: @water * other,
            lactic_acid: @lactic_acid * other,
            alcohol: @alcohol * other,
            yeast: @yeast * other,
            koji_interval_days: koji_interval_days,
            kake_interval_days: kake_interval_days,
          )
        else
          x, y = other.coerce(self)
          x * y
        end
      end

      def to_h
        {
          name: name,
          kake: kake.raw,
          koji: koji.raw,
          water: water,
          lactic_acid: lactic_acid,
          alcohol: alcohol,
          yeast: yeast,
          koji_interval_days: koji_interval_days,
          kake_interval_days: kake_interval_days,
        }
      end
    end
  end
end
