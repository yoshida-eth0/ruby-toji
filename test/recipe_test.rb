require "test_helper"

class RecipeTest < Minitest::Test
  def setup
    # 酒造教本による標準型仕込配合
    # 出典: 酒造教本 P97
    @recipe = Recipe.create(
      [
        Step.create(
          koji: Koji.create(
            raw: 20,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            tanekoji_brand: :byakuya,
            tanekoji_rate: 0.001,
            dekoji_rate: 0.18,
            interval_days: 0,
          ),
          kake: Kake.create(
            raw: 45,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            interval_days: 5,
          ),
          water: Water.create(
            weight: 70,
          ),
          lactic_acid: LacticAcid.create(
            weight: 70/100.0*0.685,
          ),
          yeast: Yeast.create(
            weight: (45+20)/100.0*1.5,
          ),
        ),
        Step.create(
          koji: Koji.create(
            raw: 40,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            tanekoji_brand: :byakuya,
            tanekoji_rate: 0.001,
            dekoji_rate: 0.18,
            interval_days: 14,
          ),
          kake: Kake.create(
            raw: 100,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            interval_days: 15,
          ),
          water: Water.create(
            weight: 130,
          ),
        ),
        Step.create(
          koji: Koji.create(
            raw: 60,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            tanekoji_brand: :byakuya,
            tanekoji_rate: 0.001,
            dekoji_rate: 0.18,
            interval_days: 0,
          ),
          kake: Kake.create(
            raw: 215,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            interval_days: 2,
          ),
          water: Water.create(
            weight: 330,
          ),
        ),
        Step.create(
          koji: Koji.create(
            raw: 80,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            tanekoji_brand: :byakuya,
            tanekoji_rate: 0.001,
            dekoji_rate: 0.18,
            interval_days: 0,
          ),
          kake: Kake.create(
            raw: 360,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            interval_days: 1,
          ),
          water: Water.create(
            weight: 630,
          ),
        ),
        Step.create(
          kake: Kake.create(
            raw: 80,
            brand: :yamadanishiki,
            made_in: :hyogo,
            year: 2020,
            soaked_rate: 0.33,
            steamed_rate: 0.41,
            cooled_rate: 0.33,
            interval_days: 25,
          ),
          water: Water.create(
            weight: 120,
          ),
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
  end

  def test_step_basic
    moto = @recipe.steps[0]

    assert_equal 20, moto.koji.raw
    assert_equal 0, moto.koji.interval_days

    assert_equal 45, moto.kake.raw
    assert_equal 5, moto.kake.interval_days

    assert_equal 70, moto.water.weight
    assert_in_delta 0.4795, moto.lactic_acid.weight
    assert_nil moto.alcohol
    assert_in_delta 0.975, moto.yeast.weight

    assert_equal 65, moto.rice_total
    assert_in_delta 0.3076923076923077, moto.koji_rate
    assert_in_delta 1.0769230769230769, moto.water_rate
  end

  def test_step_add
    moto = @recipe.steps[0]
    soe = @recipe.steps[1]
    step = moto + soe

    assert_equal 60, step.koji.raw
    assert_equal 0, step.koji.interval_days

    assert_equal 145, step.kake.raw
    assert_equal 5, step.kake.interval_days

    assert_equal 200, step.water.weight
    assert_in_delta 0.4795, step.lactic_acid.weight
    assert_nil step.alcohol
    assert_in_delta 0.975, step.yeast.weight

    assert_equal 205, step.rice_total
    assert_in_delta 0.2926829268292683, step.koji_rate
    assert_in_delta 0.975609756097561, step.water_rate
  end

  def test_step_mul
    moto = @recipe.steps[0]
    step = moto * 2

    assert_equal 40, step.koji.raw
    assert_equal 0, step.koji.interval_days

    assert_equal 90, step.kake.raw
    assert_equal 5, step.kake.interval_days

    assert_equal 140, step.water.weight
    assert_in_delta 0.959, step.lactic_acid.weight
    assert_nil step.alcohol
    assert_in_delta 1.95, step.yeast.weight

    assert_equal 130, step.rice_total
    assert_in_delta 0.3076923076923077, step.koji_rate
    assert_in_delta 1.0769230769230769, step.water_rate
  end

  def test_step_round
    moto = @recipe.steps[0]
    step = (moto * 1.3333333333333333).round

    assert_equal 27, step.koji.raw
    assert_equal 0, step.koji.interval_days

    assert_equal 60, step.kake.raw
    assert_equal 5, step.kake.interval_days

    assert_equal 93, step.water.weight
    assert_in_delta 0.639, step.lactic_acid.weight
    assert_nil step.alcohol
    assert_in_delta 1.3, step.yeast.weight

    assert_equal 87, step.rice_total
    assert_in_delta 0.3103448275862069, step.koji_rate
    assert_in_delta 1.0689655172413792, step.water_rate
  end

  def test_recipe_basic
    assert_equal 5, @recipe.steps.length

    assert_equal [65.0, 205.0, 480.0, 920.0, 1000.0], @recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3170731707317073, 0.13541666666666666, 0.07065217391304347, 0.065], @recipe.cumulative_moto_rates

    assert_equal 0.065, @recipe.moto_rate
    assert_equal [1.0, 2.1538461538461537, 4.230769230769231, 6.769230769230769, 1.2307692307692308], @recipe.rice_rates
  end

  def test_recipe_scale
    recipe = @recipe.scale(350)
  
    assert_equal [22.75, 71.75, 168.0, 322.0, 350.0], recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3170731707317073, 0.13541666666666666, 0.07065217391304347, 0.065], recipe.cumulative_moto_rates

    assert_equal 0.065, recipe.moto_rate
    assert_equal [1.0, 2.1538461538461537, 4.230769230769231, 6.769230769230769, 1.2307692307692308], recipe.rice_rates
  end

  def test_recipe_round
    recipe = @recipe.scale(350).round
  
    assert_equal [23.0, 72.0, 168.0, 322.0, 350.0], recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3194444444444444, 0.13690476190476192, 0.07142857142857142, 0.06571428571428571], recipe.cumulative_moto_rates

    assert_equal 0.06571428571428571, recipe.moto_rate
    assert_equal [1.0, 2.130434782608696, 4.173913043478261, 6.695652173913044, 1.2173913043478262], recipe.rice_rates
  end
end
