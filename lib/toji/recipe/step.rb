module Toji
  module Recipe
    module Step
      # @dynamic index
      # @dynamic subindex

      # @dynamic kojis
      # @dynamic kojis=
      # @dynamic kakes
      # @dynamic kakes=
      # @dynamic waters
      # @dynamic waters=
      # @dynamic lactic_acids
      # @dynamic lactic_acids=
      # @dynamic alcohols
      # @dynamic alcohols=
      # @dynamic yeasts
      # @dynamic yeasts=

      def moto?
        index==0
      end

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

      # 乳酸
      def lactic_acid_total
        (lactic_acids || []).map(&:weight).map(&:to_f).sum.to_f
      end

      # 醸造アルコール
      def alcohol_total
        (alcohols || []).map(&:weight).map(&:to_f).sum.to_f
      end

      # 麹歩合
      def koji_ratio
        val = koji_total / rice_total
        val.nan? ? 0.0 : val
      end

      # 汲水歩合
      def water_ratio
        val = water_total / rice_total
        val.nan? ? 0.0 : val
      end

      def ingredients(&block)
        Enumerator.new do|y|
          kojis&.each {|koji|
            y << koji
          }
          kakes&.each {|kake|
            y << kake
          }
          waters&.each {|water|
            y << water
          }
          lactic_acids&.each {|lactic_acid|
            y << lactic_acid
          }
          alcohols&.each {|alcohol|
            y << alcohol
          }
          yeasts&.each {|yeast|
            y << yeast
          }
        end.each(&block)
      end

      def scale!(ratio)
        ingredients.each {|ingredient|
          ingredient.weight *= ratio
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

      def compact!
        kojis.select! {|koji| 0<koji.weight.to_f}
        kojis.each {|koji|
          koji.tanekojis.select! {|tanekoji| 0<tanekoji.ratio.to_f}
        }
        kakes.select! {|kake| 0<kake.weight.to_f}
        waters.select! {|water| 0<water.weight.to_f}
        lactic_acids.select! {|lactic_acid| 0<lactic_acid.weight.to_f}
        alcohols.select! {|alcohol| 0<alcohol.weight.to_f}
        yeasts.select! {|yeast| 0<yeast.weight.to_f}

        self
      end

      def compact
        Utils.check_dup(self)

        dst = self.dup
        dst.compact!
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
