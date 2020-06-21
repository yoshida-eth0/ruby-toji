require "test_helper"

class RecipeTest < Minitest::Test
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
  end

  def test_step_basic
    moto = @recipe.steps[0]

    assert_equal :moto, moto.name
    assert_equal 45, moto.kake
    assert_equal 20, moto.koji
    assert_equal 70, moto.water
    assert_in_delta 0.4795, moto.lactic_acid
    assert_equal 0, moto.alcohol
    assert_in_delta 0.975, moto.yeast
    assert_equal 0, moto.koji_interval_days
    assert_equal 5, moto.kake_interval_days

    assert_equal 65, moto.rice_total
    assert_in_delta 0.3076923076923077, moto.koji_rate
    assert_in_delta 1.0769230769230769, moto.water_rate
  end

  def test_step_add
    moto = @recipe.steps[0]
    soe = @recipe.steps[1]
    step = moto + soe

    assert_equal :moto, step.name
    assert_equal 145, step.kake
    assert_equal 60, step.koji
    assert_equal 200, step.water
    assert_in_delta 0.4795, step.lactic_acid
    assert_equal 0, step.alcohol
    assert_in_delta 0.975, step.yeast
    assert_equal 0, step.koji_interval_days
    assert_equal 5, step.kake_interval_days

    assert_equal 205, step.rice_total
    assert_in_delta 0.2926829268292683, step.koji_rate
    assert_in_delta 0.975609756097561, step.water_rate
  end

  def test_step_mul
    moto = @recipe.steps[0]
    step = moto * 2

    assert_equal :moto, step.name
    assert_equal 90, step.kake
    assert_equal 40, step.koji
    assert_equal 140, step.water
    assert_in_delta 0.959, step.lactic_acid
    assert_equal 0, step.alcohol
    assert_in_delta 1.95, step.yeast
    assert_equal 0, step.koji_interval_days
    assert_equal 5, step.kake_interval_days

    assert_equal 130, step.rice_total
    assert_in_delta 0.3076923076923077, step.koji_rate
    assert_in_delta 1.0769230769230769, step.water_rate
  end

  def test_step_round
    moto = @recipe.steps[0]
    step = (moto * 1.3333333333333333).round

    assert_equal :moto, step.name
    assert_equal 60, step.kake
    assert_equal 27, step.koji
    assert_equal 93, step.water
    assert_in_delta 0.639, step.lactic_acid
    assert_equal 0, step.alcohol
    assert_in_delta 1.3, step.yeast
    assert_equal 0, step.koji_interval_days
    assert_equal 5, step.kake_interval_days

    assert_equal 87, step.rice_total
    assert_in_delta 0.3103448275862069, step.koji_rate
    assert_in_delta 1.0689655172413792, step.water_rate
  end

  def test_recipe_basic
    assert_equal 5, @recipe.steps.length

    assert_equal [65.0, 205.0, 480.0, 920.0, 1000.0], @recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3170731707317073, 0.13541666666666666, 0.07065217391304347, 0.065], @recipe.cumulative_shubo_rates

    assert_equal 0.065, @recipe.shubo_rate
    assert_equal [1.0, 2.1538461538461537, 4.230769230769231, 6.769230769230769, 1.2307692307692308], @recipe.rice_rates
  end

  def test_recipe_scale
    recipe = @recipe.scale(350)
  
    assert_equal [22.75, 71.75, 168.0, 322.0, 350.0], recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3170731707317073, 0.13541666666666666, 0.07065217391304347, 0.065], recipe.cumulative_shubo_rates

    assert_equal 0.065, recipe.shubo_rate
    assert_equal [1.0, 2.1538461538461537, 4.230769230769231, 6.769230769230769, 1.2307692307692308], recipe.rice_rates
  end

  def test_recipe_round
    recipe = @recipe.scale(350).round
  
    assert_equal [23.0, 72.0, 168.0, 322.0, 350.0], recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3194444444444444, 0.13690476190476192, 0.07142857142857142, 0.06571428571428571], recipe.cumulative_shubo_rates

    assert_equal 0.06571428571428571, recipe.shubo_rate
    assert_equal [1.0, 2.130434782608696, 4.173913043478261, 6.695652173913044, 1.2173913043478262], recipe.rice_rates
  end
end
