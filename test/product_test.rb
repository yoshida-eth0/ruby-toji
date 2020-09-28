require "test_helper"

class ProductTest < Minitest::Test
  class Product
    include Toji::Product
    include Toji::Product::EventFactory

    attr_accessor :description
    attr_accessor :color

    def initialize(name, recipe, base_date)
      @name = name
      @recipe = recipe
      @base_date = base_date
    end

    def create_koji_event(date:, index:, step_indexes:, raw:)
      KojiEvent.new(product: self, date: date, index: index, step_indexes: step_indexes, raw: raw)
    end

    def create_kake_event(date:, index:, step_indexes:, raw:)
      KakeEvent.new(product: self, date: date, index: index, step_indexes: step_indexes, raw: raw)
    end

    def create_action_event(date:, type:, index:)
      ActionEvent.new(product: self, date: date, type: type, index: index)
    end
  end

  class KojiEvent
    include Toji::Event::KojiEvent

    def initialize(product:, date:, index:, step_indexes:, raw:)
      @product = product
      @date = date
      @index = index
      @step_indexes = step_indexes
      @raw = raw
    end
  end

  class KakeEvent
    include Toji::Event::KakeEvent

    def initialize(product:, date:, index:, step_indexes:, raw:)
      @product = product
      @date = date
      @index = index
      @step_indexes = step_indexes
      @raw = raw
    end
  end

  class ActionEvent
    include Toji::Event::ActionEvent

    def initialize(product:, date:, type:, index:)
      @product = product
      @date = date
      @type = type
      @index = index
    end
  end

  class Step
    include Toji::Recipe::Step

    def self.create(koji: 0, koji_interval_days: 0, kake: 0, kake_interval_days: 0, water: 0, lactic_acid: 0, alcohol: 0, yeast: 0)
      new.tap {|o|
        o.koji = koji.to_f
        o.koji_soaked_rate = 0.0
        o.koji_steamed_rate = 0.0
        o.koji_dekoji_rate = 0.0
        o.koji_interval_days = koji_interval_days.to_i

        o.kake = kake.to_f
        o.kake_soaked_rate = 0.0
        o.kake_steamed_rate = 0.0
        o.kake_interval_days = kake_interval_days.to_i

        o.water = water.to_f
        o.lactic_acid = lactic_acid.to_f
        o.alcohol = alcohol.to_f
        o.yeast = yeast.to_f
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

    def self.create(steps, actions, has_moto, has_moromi, ab_coef, ab_expects)
      new.tap {|o|
        o.steps = steps
        o.actions = actions
        o.has_moto = has_moto
        o.has_moromi = has_moromi
        o.ab_coef = ab_coef
        o.ab_expects = ab_expects
      }
    end
  end

  def setup
    # 酒造教本による標準型仕込配合
    # 出典: 酒造教本 P97
    @recipe = Recipe.create(
      [
        Step.create(
          koji: 20,
          koji_interval_days: 0,

          kake: 45,
          kake_interval_days: 5,

          water: 70,
          lactic_acid: 70/100.0*0.685,
          yeast: (45+20)/100.0*1.5,
        ),
        Step.create(
          koji: 40,
          koji_interval_days: 14,

          kake: 100,
          kake_interval_days: 15,

          water: 130,
        ),
        Step.create(
          koji: 60,
          koji_interval_days: 0,

          kake: 215,
          kake_interval_days: 2,

          water: 330,
        ),
        Step.create(
          koji: 80,
          koji_interval_days: 0,

          kake: 360,
          kake_interval_days: 1,

          water: 630,
        ),
        Step.create(
          kake: 80,
          kake_interval_days: 25,

          water: 120,
        ),
      ].map(&:freeze).freeze,
      [
        Action.create(
          type: :squeeze,
          interval_days: 50,
        ),
      ].map(&:freeze).freeze,
      true,
      true,
      1.4,
      [],
    ).freeze

    @product = Product.new("仕1", @recipe, Time.mktime(2020, 2, 10))
  end

  def test_basic
    assert_equal "仕1", @product.name
    assert_equal @recipe, @product.recipe
    assert_equal Time.mktime(2020, 2, 10), @product.base_date

    assert_equal [Time.mktime(2020, 2, 10), Time.mktime(2020, 2, 24), Time.mktime(2020, 2, 24), Time.mktime(2020, 2, 24), Time.mktime(2020, 2, 24)], @product.koji_dates
    assert_equal [Time.mktime(2020, 2, 15), Time.mktime(2020, 3, 1), Time.mktime(2020, 3, 3), Time.mktime(2020, 3, 4), Time.mktime(2020, 3, 29)], @product.kake_dates
    assert_equal [Time.mktime(2020, 3, 31)], @product.action_dates
  end

  def test_rice_events
    rice_events = @product.rice_events
    event1 = rice_events[1]
    event4 = rice_events[4]

    assert_equal 7, rice_events.length

    assert_equal Time.mktime(2020, 2, 24), event1.date
    assert_equal :koji, event1.rice_type
    #assert_equal 180, event1.weight
    assert_equal 3, event1.step_indexes.length

    assert_equal Time.mktime(2020, 3, 3), event4.date
    assert_equal :kake, event4.rice_type
    #assert_equal 215, event4.weight
    assert_equal 1, event4.step_indexes.length
  end
end
