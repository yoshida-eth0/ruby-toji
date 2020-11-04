module Toji
  module Recipe
    module Step
      attr_reader :index
      attr_accessor :kojis
      attr_accessor :kakes
      attr_accessor :waters
      attr_accessor :lactic_acids
      attr_accessor :alcohols
      attr_accessor :yeasts

      # 麹米
      def koji_total
        (kojis || []).map(&:weight).map(&:to_f).sum.to_f
      end

      # 掛米
      def kake_total
        (kakes || []).map(&:weight).map(&:to_f).sum.to_f
      end

      # 総米
      def rice_total
        koji_total + kake_total
      end

      # 汲水
      def water_total
        (waters || []).map(&:weight).map(&:to_f).sum.to_f
      end

      # 麹歩合
      # 原料白米に占める麹米の割合
      # 留め仕込みまでの総米重量の20〜22%が標準である
      # なお、留め仕込みまでの麹歩合が20%を下回ると蒸米の溶解糖化に影響が出るので注意がいる
      # 出典: 酒造教本 P95
      def koji_ratio
        val = koji_total / rice_total
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
        val = water_total / rice_total
        val.nan? ? 0.0 : val
      end

      def scale!(ratio)
        kojis&.each {|koji|
          koji.weight *= ratio
        }
        kakes&.each {|kake|
          kake.weight *= ratio
        }
        waters&.each {|water|
          water.weight *= ratio
        }
        lactic_acids&.each {|lactic_acid|
          lactic_acid.weight *= ratio
        }
        alcohols&.each {|alcohol|
          alcohol.weight *= ratio
        }
        yeasts&.each {|yeast|
          yeast.weight *= ratio
        }
        self
      end

      def scale(ratio)
        Utils.check_dup(self)

        dst = self.dup
        dst.scale!(ratio)
      end

      def round!(ndigit=0, mini_ndigit=nil, half: :up)
        if !mini_ndigit
          mini_ndigit = ndigit + 3
        end

        kojis&.each {|koji|
          koji.weight = koji.weight.to_f.round(ndigit, half: half)
        }
        kakes&.each {|kake|
          kake.weight = kake.weight.to_f.round(ndigit, half: half)
        }
        waters&.each {|water|
          water.weight = water.weight.to_f.round(ndigit, half: half)
        }
        lactic_acids&.each {|lactic_acid|
          lactic_acid.weight = lactic_acid.weight.to_f.round(mini_ndigit, half: half)
        }
        alcohols&.each {|alcohol|
          alcohol.weight = alcohol.weight.to_f.round(ndigit, half: half)
        }
        yeasts&.each {|yeast|
          yeast.weight = yeast.weight.to_f.round(mini_ndigit, half: half)
        }

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
          Utils.check_dup(other)

          dst = self.dup
          other = other.dup

          dst.kojis = Utils.merge_ingredients(dst.kojis, other.kojis)
          dst.kakes = Utils.merge_ingredients(dst.kakes, other.kakes)
          dst.waters = Utils.merge_ingredients(dst.waters, other.waters)
          dst.lactic_acids = Utils.merge_ingredients(dst.lactic_acids, other.lactic_acids)
          dst.alcohols = Utils.merge_ingredients(dst.alcohols, other.alcohols)
          dst.yeasts = Utils.merge_ingredients(dst.yeasts, other.yeasts)

          dst
        else
          x, y = other.coerce(self)
          x + y
        end
      end

      def *(other)
        if Integer===other || Float===other
          scale(other)
        else
          x, y = other.coerce(self)
          x * y
        end
      end
    end
  end
end
