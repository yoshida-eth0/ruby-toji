$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require 'securerandom'

module Example

  class Product
    include Toji::Product
    include Toji::Product::ScheduleFactory

    attr_reader :name
    attr_reader :recipe
    attr_reader :base_date

    attr_reader :description
    attr_reader :color

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
        if args[:scale_rice_total]
          recipe = recipe.scale_rice_total(args[:scale_rice_total])
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

    attr_reader :index
    attr_reader :subindex
    attr_accessor :kojis
    attr_accessor :kakes
    attr_accessor :waters
    attr_accessor :lactic_acids
    attr_accessor :alcohols
    attr_accessor :yeasts

    def initialize(index:, subindex:, kojis: [], kakes: [], waters: [], lactic_acids: [], alcohols: [], yeasts: [])
      @index = index
      @subindex = subindex
      @kojis = kojis
      @kakes = kakes
      @waters = waters
      @lactic_acids = lactic_acids
      @alcohols = alcohols
      @yeasts = yeasts
    end

    def initialize_copy(obj)
      @kojis = obj.kojis.deep_dup
      @kakes = obj.kakes.deep_dup
      @waters = obj.waters.deep_dup
      @lactic_acids = obj.lactic_acids.deep_dup
      @alcohols = obj.alcohols.deep_dup
      @yeasts = obj.yeasts.deep_dup
    end
  end

  class Koji
    include Toji::Ingredient::Koji

    attr_accessor :weight
    attr_reader :brand
    attr_reader :polishing_ratio
    attr_reader :made_in
    attr_reader :year
    attr_reader :soaking_ratio
    attr_reader :steaming_ratio
    attr_reader :cooling_ratio
    attr_reader :tanekojis
    attr_reader :dekoji_ratio
    attr_reader :interval_days

    def initialize(weight:, brand:, polishing_ratio:, made_in:, year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, tanekojis:, dekoji_ratio:, interval_days:)
      @weight = weight
      @brand = brand
      @polishing_ratio = polishing_ratio
      @made_in = made_in
      @year = year
      @soaking_ratio = soaking_ratio
      @steaming_ratio = steaming_ratio
      @cooling_ratio = cooling_ratio
      @tanekojis = tanekojis.map {|tanekoji|
        tanekoji.koji = self
        tanekoji
      }
      @dekoji_ratio = dekoji_ratio
      @interval_days = interval_days
    end

    def initialize_copy(obj)
      @weight = obj.weight.dup
      @brand = obj.brand.dup
      @polishing_ratio = obj.polishing_ratio.dup
      @made_in = obj.made_in.dup
      @year = obj.year.dup
      @soaking_ratio = obj.soaking_ratio.dup
      @steaming_ratio = obj.steaming_ratio.dup
      @cooling_ratio = obj.cooling_ratio.dup

      @tanekojis = obj.tanekojis.map {|tanekoji|
        tanekoji = tanekoji.dup
        tanekoji.koji = self
        tanekoji
      }

      @dekoji_ratio = obj.dekoji_ratio.dup
      @interval_days = obj.interval_days.dup
    end
  end

  class Tanekoji
    include Toji::Ingredient::Tanekoji

    attr_accessor :koji
    attr_reader :brand
    attr_reader :ratio

    def initialize(koji: nil, brand:, ratio:)
      @brand = brand
      @ratio = ratio
    end

    def initialize_copy(obj)
      @brand = obj.brand.dup
      @ratio = obj.ratio.dup
    end
  end

  class Kake
    include Toji::Ingredient::Kake

    attr_accessor :weight
    attr_reader :brand
    attr_reader :polishing_ratio
    attr_reader :made_in
    attr_reader :year
    attr_reader :soaking_ratio
    attr_reader :steaming_ratio
    attr_reader :cooling_ratio
    attr_reader :interval_days

    def initialize(weight:, brand:, polishing_ratio:, made_in:, year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, interval_days:)
      @weight = weight
      @brand = brand
      @polishing_ratio = polishing_ratio
      @made_in = made_in
      @year = year
      @soaking_ratio = soaking_ratio
      @steaming_ratio = steaming_ratio
      @cooling_ratio = cooling_ratio
      @interval_days = interval_days
    end
  end

  class Water
    include Toji::Ingredient::Water

    attr_accessor :weight
    attr_reader :calcium_hardness
    attr_reader :magnesium_hardness

    def initialize(weight:)
      @weight = weight
    end
  end

  class LacticAcid
    include Toji::Ingredient::LacticAcid

    attr_accessor :weight

    def initialize(weight:)
      @weight = weight
    end
  end

  class Alcohol
    include Toji::Ingredient::Alcohol

    attr_accessor :weight

    def initialize(weight:)
      @weight = weight
    end
  end

  class Yeast
    include Toji::Ingredient::Yeast

    attr_accessor :weight
    attr_reader :unit
    attr_reader :brand

    def initialize(weight:)
      @weight = weight
    end
  end


  class Action
    include Toji::Recipe::Action

    attr_reader :type
    attr_reader :interval_days

    def initialize(type:, interval_days:)
      @type = type
      @interval_days = interval_days
    end
  end

  class AbExpect
    include Toji::Recipe::AbExpect

    attr_reader :alcohol
    attr_reader :nihonshudo

    def initialize(alcohol:, nihonshudo:)
      @alcohol = alcohol
      @nihonshudo = nihonshudo
    end
  end


  class Recipe
    include Toji::Recipe

    attr_reader :steps
    attr_reader :actions
    attr_reader :ab_coef
    attr_reader :ab_expects

    def initialize(steps:, actions:, ab_coef:, ab_expects:)
      @steps = steps
      @actions = actions
      @ab_coef = ab_coef
      @ab_expects = ab_expects
    end

    def initialize_copy(obj)
      @steps = obj.steps.deep_dup
      @actions = obj.actions.deep_dup
      @ab_coef = obj.ab_coef.dup
      @ab_expects = obj.ab_expects.deep_dup
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
      sokujo_textbook: new(
        steps: [
          Step.new(
            index: 0,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 20,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.new(
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
              Water.new(
                weight: 70,
              ),
            ],
            lactic_acids: [
              LacticAcid.new(
                weight: 70/100.0*0.685,
              ),
            ],
            yeasts: [
              Yeast.new(
                weight: (45+20)/100.0*1.5,
              ),
            ]
          ),
          Step.new(
            index: 1,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 40,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 14,
              ),
            ],
            kakes: [
              Kake.new(
                weight: 100,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 20,
              ),
            ],
            waters: [
              Water.new(
                weight: 130,
              ),
            ],
          ),
          Step.new(
            index: 2,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 60,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 14,
              ),
            ],
            kakes: [
              Kake.new(
                weight: 215,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 22,
              ),
            ],
            waters: [
              Water.new(
                weight: 330,
              ),
            ],
          ),
          Step.new(
            index: 3,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 80,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 14,
              ),
            ],
            kakes: [
              Kake.new(
                weight: 360,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 23,
              ),
            ],
            waters: [
              Water.new(
                weight: 630,
              ),
            ],
          ),
          Step.new(
            index: 4,
            subindex: 0,
            kakes: [
              Kake.new(
                weight: 80,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 48,
              ),
            ],
            waters: [
              Water.new(
                weight: 120,
              ),
            ],
          ),
        ].map(&:freeze).freeze,
        actions: [
          Action.new(
            type: :squeeze,
            interval_days: 50,
          ),
        ].map(&:freeze).freeze,
        ab_coef: 1.4,
        ab_expects: [
          AbExpect.new(
            alcohol: 15.0,
            nihonshudo: 0.0,
          ),
          AbExpect.new(
            alcohol: 16.0,
            nihonshudo: 3.0,
          ),
        ].map(&:freeze).freeze,
      ).freeze,
      # 灘における仕込配合の平均値
      # 出典: http://www.nada-ken.com/main/jp/index_shi/234.html
      sokujo_nada: new(
        steps: [
          Step.new(
            index: 0,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 47,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.new(
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
              Water.new(
                weight: 170,
              ),
            ],
            lactic_acids: [
              LacticAcid.new(
                weight: 170/100.0*0.685,
              ),
            ],
            yeasts: [
              Yeast.new(
                weight: (93+47)/100.0*1.5,
              ),
            ],
          ),
          Step.new(
            index: 1,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 99,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 14,
              ),
            ],
            kakes: [
              Kake.new(
                weight: 217,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 20,
              ),
            ],
            waters: [
              Water.new(
                weight: 270,
              ),
            ],
          ),
          Step.new(
            index: 2,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 143,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 14,
              ),
            ],
            kakes: [
              Kake.new(
                weight: 423,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 22,
              ),
            ],
            waters: [
              Water.new(
                weight: 670,
              ),
            ],
          ),
          Step.new(
            index: 3,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 165,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 14,
              ),
            ],
            kakes: [
              Kake.new(
                weight: 813,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 23,
              ),
            ],
            waters: [
              Water.new(
                weight: 1330,
              ),
            ],
          ),
          Step.new(
            index: 4,
            subindex: 0,
            alcohols: [
              Alcohol.new(
                weight: 900,
              ),
            ],
          ),
        ].map(&:freeze).freeze,
        actions: [
          Action.new(
            type: :squeeze,
            interval_days: 50,
          ),
        ].map(&:freeze).freeze,
        ab_coef: 1.4,
        ab_expects: [
          AbExpect.new(
            alcohol: 15.0,
            nihonshudo: 0.0,
          ),
          AbExpect.new(
            alcohol: 16.0,
            nihonshudo: 3.0,
          ),
        ].map(&:freeze).freeze,
      ).freeze,
      # 簡易酒母省略仕込
      # 出典: https://www.jstage.jst.go.jp/article/jbrewsocjapan1915/60/11/60_11_999/_article/-char/ja/
      simple_sokujo_himeno: new(
        steps: [
          Step.new(
            index: 0,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 70,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
            ],
            waters: [
              Water.new(
                weight: 245,
              ),
            ],
            lactic_acids: [
              LacticAcid.new(
                weight: 1.6,
              ),
            ],
            yeasts: [
              Yeast.new(
                weight: 5,
              ),
            ],
          ),
          Step.new(
            index: 1,
            subindex: 0,
            kojis: [
            ],
            kakes: [
              Kake.new(
                weight: 130,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 7,
              ),
            ],
            waters: [
              Water.new(
                weight: 0,
              ),
            ],
          ),
          Step.new(
            index: 2,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 100,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.new(
                weight: 300,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 9,
              ),
            ],
            waters: [
              Water.new(
                weight: 400,
              ),
            ],
          ),
          Step.new(
            index: 3,
            subindex: 0,
            kojis: [
              Koji.new(
                weight: 110,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                tanekojis: [
                  Tanekoji.new(
                    brand: :byakuya,
                    ratio: 0.001,
                  ),
                ],
                dekoji_ratio: 0.18,
                interval_days: 0,
              ),
            ],
            kakes: [
              Kake.new(
                weight: 490,
                brand: :yamadanishiki,
                polishing_ratio: 0.55,
                made_in: :hyogo,
                year: 2020,
                soaking_ratio: 0.33,
                steaming_ratio: 0.41,
                cooling_ratio: 0.33,
                interval_days: 10,
              ),
            ],
            waters: [
              Water.new(
                weight: 800,
              ),
            ],
          ),
          Step.new(
            index: 4,
            subindex: 0,
            waters: [
              Water.new(
                weight: 255,
              ),
            ],
          ),
        ].map(&:freeze).freeze,
        actions: [
          Action.new(
            type: :squeeze,
            interval_days: 50,
          ),
        ].map(&:freeze).freeze,
        ab_coef: 1.4,
        ab_expects: [
          AbExpect.new(
            alcohol: 15.0,
            nihonshudo: 0.0,
          ),
          AbExpect.new(
            alcohol: 16.0,
            nihonshudo: 3.0,
          ),
        ].map(&:freeze).freeze,
      ).freeze,
    }.freeze
  end


  class KojiSchedule
    include Toji::Schedule::KojiSchedule

    attr_reader :product
    attr_reader :date

    attr_reader :step_indexes
    attr_reader :expect

    def initialize(product:, date:, step_indexes:, expect:)
      @product = product
      @date = date
      @step_indexes = step_indexes
      @expect = expect
    end
  end

  class KakeSchedule
    include Toji::Schedule::KakeSchedule

    attr_reader :product
    attr_reader :date

    attr_reader :step_indexes
    attr_reader :expect

    def initialize(product:, date:, step_indexes:, expect:)
      @product = product
      @date = date
      @step_indexes = step_indexes
      @expect = expect
    end
  end

  class ActionSchedule
    include Toji::Schedule::ActionSchedule

    attr_reader :product
    attr_reader :date
    attr_reader :type

    attr_reader :index_index

    def initialize(product:, date:, type:, action_index:)
      @product = product
      @date = date
      @type = type
      @action_index = action_index
    end
  end


  module Progress
    module ProgressGenerator
      def load_hash(hash)
        hash = hash.deep_symbolize_keys

        builder
          .add(hash[:states] || [])
          .date_line(hash[:date_line] || 0, Toji::Progress::HOUR)
          .prefix_day_labels(hash[:prefix_day_labels])
          .build
      end

      def load_yaml_file(fname)
        hash = YAML.load_file(fname)
        load_hash(hash)
      end
    end

    class KojiProgress
      include Toji::Progress::KojiProgress
      extend ProgressGenerator

      attr_accessor :states
      attr_accessor :date_line

      def self.builder
        Toji::Progress::Builder.new(KojiProgress, KojiState)
      end
    end

    class KojiState
      include Toji::Progress::KojiState

      attr_accessor :progress
      attr_accessor :time
      attr_accessor :mark

      attr_accessor :temps
      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry
      attr_accessor :note

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
      include Toji::Progress::MotoProgress
      extend ProgressGenerator

      attr_accessor :states
      attr_accessor :date_line

      def self.builder
        Toji::Progress::Builder.new(MotoProgress, MotoState)
      end
    end

    class MotoState
      include Toji::Progress::MotoState

      attr_accessor :progress
      attr_accessor :time
      attr_accessor :mark

      attr_accessor :temps
      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry
      attr_accessor :baume
      attr_accessor :acid
      attr_accessor :warmings
      attr_accessor :note

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
      include Toji::Progress::MoromiProgress
      extend ProgressGenerator

      attr_accessor :states
      attr_accessor :date_line
      attr_accessor :prefix_day_labels

      def self.builder
        Toji::Progress::Builder.new(MoromiProgress, MoromiState)
      end
    end

    class MoromiState
      include Toji::Progress::MoromiState
      include Toji::Progress::State::BaumeToNihonshudo

      attr_accessor :progress
      attr_accessor :time
      attr_accessor :mark

      attr_accessor :temps
      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry
      attr_accessor :baume
      attr_accessor :acid
      attr_accessor :amino_acid
      attr_accessor :alcohol
      attr_accessor :warmings
      attr_accessor :note

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
