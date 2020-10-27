$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require 'securerandom'

module Example

  class Product
    include Toji::Product
    include Toji::Product::ScheduleFactory

    attr_accessor :description
    attr_accessor :color

    def initialize(id, name, description, recipe, base_date, color=nil)
      @id = id
      @name = name
      @description = description
      @recipe = recipe
      @base_date = base_date
      @color = color
    end

    def create_koji_schedule(date:, step_indexes:, kojis:)
      expect = kojis.first.dup
      expect.weight = kojis.map(&:weight).sum

      KojiSchedule.new(
        product: self,
        date: date,
        step_indexes: step_indexes,
        expect: expect,
      )
    end

    def create_kake_schedule(date:, step_indexes:, kakes:)
      expect = kakes.first.dup
      expect.weight = kakes.map(&:weight).sum

      KakeSchedule.new(
        product: self,
        date: date,
        step_indexes: step_indexes,
        expect: expect,
      )
    end

    def create_action_schedule(date:, action_index:, action:)
      ActionSchedule.new(
        product: self,
        date: date,
        type: action.type,
        action_index: index,
      )
    end

    def self.create(args)
      if self===args
        args
      elsif Hash===args
        recipe = args.fetch(:recipe)
        if Symbol===recipe
          recipe = Recipe::TEMPLATES.fetch(recipe)
        end
        if args[:scale]
          recipe = recipe.scale(args[:scale])
        end
        if args[:round]
          recipe = recipe.round(args[:round])
        end

        new(
          args[:id],
          args[:name],
          args[:description],
          recipe,
          args[:base_date],
          args[:color]
        )
      else
        raise "not supported class: #{args.class}"
      end
    end
  end


  class Step
    include Toji::Recipe::Step

    def initialize_copy(obj)
      self.kojis = obj.kojis.deep_dup
      self.kakes = obj.kakes.deep_dup
      self.waters = obj.waters.deep_dup
      self.lactic_acids = obj.lactic_acids.deep_dup
      self.alcohols = obj.alcohols.deep_dup
      self.yeasts = obj.yeasts.deep_dup
    end

    def self.create(kojis: [], kakes: [], waters: [], lactic_acids: [], alcohols: [], yeasts: [])
      new.tap {|o|
        o.kojis = kojis
        o.kakes = kakes
        o.waters = waters
        o.lactic_acids = lactic_acids
        o.alcohols = alcohols
        o.yeasts = yeasts
      }
    end
  end

  class Koji
    include Toji::Ingredient::Koji

    attr_accessor :weight
    attr_accessor :soaking_ratio
    attr_accessor :steaming_ratio
    attr_accessor :cooling_ratio
    attr_accessor :tanekojis
    attr_accessor :dekoji_ratio
    attr_accessor :interval_days

    def initialize_copy(obj)
      self.weight = obj.weight.dup
      self.brand = obj.brand.dup
      self.polishing_ratio = obj.polishing_ratio.dup
      self.made_in = obj.made_in.dup
      self.year = obj.year.dup
      self.soaking_ratio = obj.soaking_ratio.dup
      self.steaming_ratio = obj.steaming_ratio.dup
      self.cooling_ratio = obj.cooling_ratio.dup

      self.tanekojis = obj.tanekojis.map {|tanekoji|
        tanekoji = tanekoji.dup
        tanekoji.koji = self
        tanekoji
      }

      self.dekoji_ratio = obj.dekoji_ratio.dup
      self.interval_days = obj.interval_days.dup
    end

    def self.create(weight:, brand:, polishing_ratio:, made_in:, year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, tanekojis:, dekoji_ratio:, interval_days:)
      new.tap {|o|
        o.weight = weight
        o.brand = brand
        o.polishing_ratio = polishing_ratio
        o.made_in = made_in
        o.year = year
        o.soaking_ratio = soaking_ratio
        o.steaming_ratio = steaming_ratio
        o.cooling_ratio = cooling_ratio
        o.tanekojis = tanekojis.map {|tanekoji|
          tanekoji.koji = o
          tanekoji
        }
        o.dekoji_ratio = dekoji_ratio
        o.interval_days = interval_days
      }
    end
  end

  class Tanekoji
    include Toji::Ingredient::Tanekoji

    def initialize_copy(obj)
      self.brand = obj.brand.dup
      self.ratio = obj.ratio.dup
    end

    def self.create(koji: nil, brand:, ratio:)
      new.tap {|o|
        o.brand = brand
        o.ratio = ratio
      }
    end
  end

  class Kake
    include Toji::Ingredient::Kake

    attr_accessor :weight
    attr_accessor :soaking_ratio
    attr_accessor :steaming_ratio
    attr_accessor :cooling_ratio
    attr_accessor :interval_days

    def self.create(weight:, brand:, polishing_ratio:, made_in:, year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, interval_days:)
      new.tap {|o|
        o.weight = weight
        o.brand = brand
        o.polishing_ratio = polishing_ratio
        o.made_in = made_in
        o.year = year
        o.soaking_ratio = soaking_ratio
        o.steaming_ratio = steaming_ratio
        o.cooling_ratio = cooling_ratio
        o.interval_days = interval_days
      }
    end
  end

  class Water
    include Toji::Ingredient::Water

    attr_accessor :weight

    def self.create(weight:)
      new.tap {|o|
        o.weight = weight
      }
    end
  end

  class LacticAcid
    include Toji::Ingredient::LacticAcid

    attr_accessor :weight

    def self.create(weight:)
      new.tap {|o|
        o.weight = weight
      }
    end
  end

  class Alcohol
    include Toji::Ingredient::Alcohol

    attr_accessor :weight

    def self.create(weight:)
      new.tap {|o|
        o.weight = weight
      }
    end
  end

  class Yeast
    include Toji::Ingredient::Yeast

    attr_accessor :weight

    def self.create(weight:)
      new.tap {|o|
        o.weight = weight
      }
    end
  end


  class Action
    include Toji::Recipe::Action

    def self.create(type:, interval_days:)
      new.tap {|o|
        o.type = type
        o.interval_days = interval_days
      }
    end
  end


  class Recipe
    include Toji::Recipe

    def initialize
      @steps = []
    end

    def self.create(steps)
      new.tap {|o|
        o.steps = steps
      }
    end

    # 乳酸は汲水100L当たり比重1.21の乳酸(90%乳酸と称される)を650〜720ml添加する。
    # 添加する酵母の量は、酒母の総米100kg当たり協会酵母アンプル1〜2本である。
    #
    # 出典: 酒造教本 P80
    #
    # ここでは間をとって乳酸は685ml、酵母は1.5本とする。
    TEMPLATES = {
      # 酒造教本による標準型仕込配合
      # 出典: 酒造教本 P97
      sokujo_textbook: create(
        [
          Step.create(
            kojis: [
              Koji.create(
                weight: 20,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 45,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 5,
              ),
            ],
            waters: [
              Water.create(
                weight: 70,
              ),
            ],
            lactic_acids: [
              LacticAcid.create(
                weight: 70/100.0*0.685,
              ),
            ],
            yeasts: [
              Yeast.create(
                weight: (45+20)/100.0*1.5,
              ),
            ]
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 40,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 14,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 100,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 15,
              ),
            ],
            waters: [
              Water.create(
                weight: 130,
              ),
            ],
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 60,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 215,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 2,
              ),
            ],
            waters: [
              Water.create(
                weight: 330,
              ),
            ],
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 80,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 360,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 1,
              ),
            ],
            waters: [
              Water.create(
                weight: 630,
              ),
            ],
          ),
          Step.create(
            kakes: [
              Kake.create(
                weight: 80,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 25,
              ),
            ],
            waters: [
              Water.create(
                weight: 120,
              ),
            ],
          ),
        ].map(&:freeze).freeze
      ).freeze,
      # 灘における仕込配合の平均値
      # 出典: http://www.nada-ken.com/main/jp/index_shi/234.html
      sokujo_nada: create(
        [
          Step.create(
            kojis: [
              Koji.create(
                weight: 47,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 93,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 5,
              ),
            ],
            waters: [
              Water.create(
                weight: 170,
              ),
            ],
            lactic_acids: [
              LacticAcid.create(
                weight: 170/100.0*0.685,
              ),
            ],
            yeasts: [
              Yeast.create(
                weight: (93+47)/100.0*1.5,
              ),
            ],
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 99,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 14,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 217,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 15,
              ),
            ],
            waters: [
              Water.create(
                weight: 270,
              ),
            ],
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 143,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 423,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 2,
              ),
            ],
            waters: [
              Water.create(
                weight: 670,
              ),
            ],
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 165,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 813,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 1,
              ),
            ],
            waters: [
              Water.create(
                weight: 1330,
              ),
            ],
          ),
          Step.create(
            alcohols: [
              Alcohol.create(
                weight: 900,
              ),
            ],
          ),
        ].map(&:freeze).freeze
      ).freeze,
      # 簡易酒母省略仕込
      # 出典: https://www.jstage.jst.go.jp/article/jbrewsocjapan1915/60/11/60_11_999/_article/-char/ja/
      simple_sokujo_himeno: create(
        [
          Step.create(
            kojis: [
              Koji.create(
                weight: 70,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 0,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 6,
              ),
            ],
            waters: [
              Water.create(
                weight: 245,
              ),
            ],
            lactic_acids: [
              LacticAcid.create(
                weight: 1.6,
              ),
            ],
            yeasts: [
              Yeast.create(
                weight: 5,
              ),
            ],
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 0,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 130,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 1,
              ),
            ],
            waters: [
              Water.create(
                weight: 0,
              ),
            ],
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 100,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 300,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 2,
              ),
            ],
            waters: [
              Water.create(
                weight: 400,
              ),
            ],
          ),
          Step.create(
            kojis: [
              Koji.create(
                weight: 110,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.create(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.create(
                weight: 490,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 1,
              ),
            ],
            waters: [
              Water.create(
                weight: 800,
              ),
            ],
          ),
          Step.create(
            waters: [
              Water.create(
                weight: 255,
              ),
            ],
          ),
        ].map(&:freeze).freeze
      ).freeze,
    }.freeze
  end


  class KojiSchedule
    include Toji::Schedule::KojiSchedule

    def initialize(product:, date:, step_indexes:, expect:)
      @product = product
      @date = date
      @step_indexes = step_indexes
      @expect = expect
    end
  end

  class KakeSchedule
    include Toji::Schedule::KakeSchedule

    def initialize(product:, date:, step_indexes:, expect:)
      @product = product
      @date = date
      @step_indexes = step_indexes
      @expect = expect
    end
  end

  class ActionSchedule
    include Toji::Schedule::ActionSchedule

    def initialize(product:, date:, type:, action_index:)
      @product = product
      @date = date
      @type = type
      @action_index = action_index
    end
  end


  module Brew
    module BrewGenerator
      def load_hash(hash)
        hash = hash.deep_symbolize_keys

        builder
          .add(hash[:states] || [])
          .date_line(hash[:date_line] || 0, Toji::Brew::HOUR)
          .prefix_day_labels(hash[:prefix_day_labels])
          .build
      end

      def load_yaml_file(fname)
        hash = YAML.load_file(fname)
        load_hash(hash)
      end
    end

    class KojiProgress
      include Toji::Brew::KojiProgress
      extend BrewGenerator

      attr_accessor :states
      attr_accessor :date_line

      def self.builder
        Toji::Brew::Builder.new(KojiProgress, KojiState)
      end
    end

    class KojiState
      include Toji::Brew::KojiState

      def self.create(args)
        new.tap {|s|
          s.progress = args[:progress]
          s.time = args[:time].to_time
          s.mark = args[:mark]
          s.temps = [args[:temps]].flatten.compact
          s.preset_temp = args[:preset_temp]
          s.room_temp = args[:room_temp]
          s.room_psychrometry = args[:room_psychrometry]
          s.note = args[:note]
        }
      end
    end

    class MotoProgress
      include Toji::Brew::MotoProgress
      extend BrewGenerator

      attr_accessor :states
      attr_accessor :date_line

      def self.builder
        Toji::Brew::Builder.new(MotoProgress, MotoState)
      end
    end

    class MotoState
      include Toji::Brew::MotoState

      def self.create(args)
        new.tap {|s|
          s.progress = args[:progress]
          s.time = args[:time].to_time
          s.mark = args[:mark]
          s.temps = [args[:temps]].flatten.compact
          s.preset_temp = args[:preset_temp]
          s.room_temp = args[:room_temp]
          s.room_psychrometry = args[:room_psychrometry]
          s.baume = args[:baume]
          s.acid = args[:acid]
          s.warmings = [args[:warmings]].flatten.compact
          s.note = args[:note]
        }
      end
    end


    class MoromiProgress
      include Toji::Brew::MoromiProgress
      extend BrewGenerator

      attr_accessor :states
      attr_accessor :date_line
      attr_accessor :prefix_day_labels

      def self.builder
        Toji::Brew::Builder.new(MoromiProgress, MoromiState)
      end
    end

    class MoromiState
      include Toji::Brew::MoromiState
      include Toji::Brew::State::BaumeToNihonshudo

      def self.create(args)
        new.tap {|s|
          s.progress = args[:progress]
          s.time = args[:time].to_time
          s.mark = args[:mark]
          s.temps = [args[:temps]].flatten.compact
          s.preset_temp = args[:preset_temp]
          s.room_temp = args[:room_temp]
          s.room_psychrometry = args[:room_psychrometry]
          if args[:baume]
            s.baume = args[:baume]
          else
            s.nihonshudo = args[:nihonshudo]
          end
          s.acid = args[:acid]
          s.amino_acid = args[:amino_acid]
          s.alcohol = args[:alcohol]
          s.warmings = [args[:warmings]].flatten.compact
          s.note = args[:note]
        }
      end
    end
  end


  class Calendar < Toji::Calendar

    def self.load_hash(hash)
      hash = hash.deep_symbolize_keys
      products = hash[:products] || []

      cal = new
      products.each {|product|
        cal.add(Product.create(product))
      }

      cal
    end

    def self.load_yaml_file(fname)
      hash = YAML.load_file(fname)
      load_hash(hash)
    end
  end
end
