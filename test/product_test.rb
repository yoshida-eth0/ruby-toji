require "test_helper"

class ProductTest < Minitest::Test
  class Product
    include Toji::Product

    attr_accessor :description
    attr_accessor :color

    def initialize(reduce_key, name, recipe, base_date)
      @reduce_key = reduce_key || SecureRandom.uuid
      @name = name
      @recipe = recipe
      @base_date = base_date
    end
  end

  class Step
    include Toji::Recipe::Step

    def self.create(name:, kake: 0, koji: 0, water: 0, lactic_acid: 0, alcohol: 0, yeast: 0, koji_interval_days: 0, kake_interval_days: 0)
      new.tap {|o|
        o.name = name
        o.kake = kake.to_f
        o.koji = koji.to_f
        o.water = water.to_f
        o.lactic_acid = lactic_acid.to_f
        o.alcohol = alcohol.to_f
        o.yeast = yeast.to_f
        o.koji_interval_days = koji_interval_days.to_i
        o.kake_interval_days = kake_interval_days.to_i
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
  end

  def setup
    # 酒造教本による標準型仕込配合
    # 出典: 酒造教本 P97
    @recipe = Recipe.create(
      [
        Step.create(
          name: :moto,
          kake: 45,
          koji: 20,
          water: 70,
          lactic_acid: 70/100.0*0.685,
          yeast: (45+20)/100.0*1.5,
          koji_interval_days: 0,
          kake_interval_days: 5,
        ),
        Step.create(
          name: :soe,
          kake: 100,
          koji: 40,
          water: 130,
          koji_interval_days: 14,
          kake_interval_days: 15,
        ),
        Step.create(
          name: :naka,
          kake: 215,
          koji: 60,
          water: 330,
          koji_interval_days: 0,
          kake_interval_days: 2,
        ),
        Step.create(
          name: :tome,
          kake: 360,
          koji: 80,
          water: 630,
          koji_interval_days: 0,
          kake_interval_days: 1,
        ),
        Step.create(
          name: :yodan,
          kake: 80,
          water: 120,
          kake_interval_days: 25,
        ),
      ].map(&:freeze).freeze
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
  end

  def test_events
    events = @product.events
    event0 = events[0]
    event7 = events[7]

    assert_equal 10, events.length

    assert_equal Time.mktime(2020, 2, 10), event0.date
    assert_equal :koji, event0.type
    assert_equal 0, event0.index
    assert_equal 0, event0.group_index
    assert_equal 20, event0.weight

    assert_equal Time.mktime(2020, 3, 3), event7.date
    assert_equal :kake, event7.type
    assert_equal 2, event7.index
    assert_equal 2, event7.group_index
    assert_equal 215, event7.weight
  end

  def test_events_group
    events_group = @product.events_group
    eg1 = events_group[1]
    eg4 = events_group[4]

    assert_equal 7, events_group.length

    assert_equal Time.mktime(2020, 2, 24), eg1[:date]
    assert_equal :koji, eg1[:type]
    assert_equal 180, eg1[:weight]
    assert_equal 3, eg1[:breakdown].length

    assert_equal Time.mktime(2020, 3, 3), eg4[:date]
    assert_equal :kake, eg4[:type]
    assert_equal 215, eg4[:weight]
    assert_equal 1, eg4[:breakdown].length
  end
end
