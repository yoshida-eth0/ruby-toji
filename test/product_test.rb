require "test_helper"

class ProductTest < Minitest::Test
  class Product
    include Toji::Product
    include Toji::Product::EventFactory

    attr_accessor :description
    attr_accessor :color

    def initialize(reduce_key, name, recipe, base_date)
      @reduce_key = reduce_key || SecureRandom.uuid
      @name = name
      @recipe = recipe
      @base_date = base_date
    end

    def create_rice_event(product:, date:, rice_type:, index:, group_index:, weight:)
      RiceEvent.new(product: product, date: date, rice_type: rice_type, index: index, group_index: group_index, weight: weight)
    end

    def create_rice_event_group(date:, rice_type:, breakdown:)
      RiceEventGroup.new(date: date, rice_type: rice_type, breakdown: breakdown)
    end

    def create_action_event(product:, date:, type:, index:)
      ActionEvent.new(product: product, date: date, type: type, index: index)
    end
  end

  class RiceEvent
    include Toji::Product::RiceEvent

    def initialize(product:, date:, rice_type:, index:, group_index:, weight:)
      @product = product
      @date = date
      @rice_type = rice_type
      @index = index
      @group_index = group_index
      @weight = weight
    end
  end

  class RiceEventGroup
    include Toji::Product::RiceEventGroup

    def initialize(date:, rice_type:, breakdown:)
      @date = date
      @rice_type = rice_type
      @breakdown = breakdown
    end
  end

  class ActionEvent
    include Toji::Product::ActionEvent

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

    @product = Product.new("asdfghjkl", "仕1", @recipe, Time.mktime(2020, 2, 10))
  end

  def test_basic
    assert_equal "asdfghjkl", @product.reduce_key
    assert_equal "仕1", @product.name
    assert_equal @recipe, @product.recipe
    assert_equal Time.mktime(2020, 2, 10), @product.base_date

    assert_equal [Time.mktime(2020, 2, 10), Time.mktime(2020, 2, 24), Time.mktime(2020, 2, 24), Time.mktime(2020, 2, 24), Time.mktime(2020, 2, 24)], @product.koji_dates
    assert_equal [Time.mktime(2020, 2, 15), Time.mktime(2020, 3, 1), Time.mktime(2020, 3, 3), Time.mktime(2020, 3, 4), Time.mktime(2020, 3, 29)], @product.kake_dates
    assert_equal [Time.mktime(2020, 3, 31)], @product.action_dates
  end

  def test_events
    events = @product.rice_events
    event0 = events[0]
    event7 = events[7]

    assert_equal 10, events.length

    assert_equal Time.mktime(2020, 2, 10), event0.date
    assert_equal :koji, event0.rice_type
    assert_equal 0, event0.index
    assert_equal 0, event0.group_index
    assert_equal 20, event0.weight

    assert_equal Time.mktime(2020, 3, 3), event7.date
    assert_equal :kake, event7.rice_type
    assert_equal 2, event7.index
    assert_equal 2, event7.group_index
    assert_equal 215, event7.weight
  end

  def test_rice_event_groups
    rice_event_groups = @product.rice_event_groups
    eg1 = rice_event_groups[1]
    eg4 = rice_event_groups[4]

    assert_equal 7, rice_event_groups.length

    assert_equal Time.mktime(2020, 2, 24), eg1.date
    assert_equal :koji, eg1.rice_type
    assert_equal 180, eg1.weight
    assert_equal 3, eg1.breakdown.length

    assert_equal Time.mktime(2020, 3, 3), eg4.date
    assert_equal :kake, eg4.rice_type
    assert_equal 215, eg4.weight
    assert_equal 1, eg4.breakdown.length
  end
end
