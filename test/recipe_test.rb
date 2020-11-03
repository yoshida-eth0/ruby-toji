require "test_helper"

class RecipeTest < Minitest::Test
  def setup
    # 酒造教本による標準型仕込配合
    # 出典: 酒造教本 P97
    @recipe = Recipe.new(
      steps: [
        Step.new(
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
          ],
        ),
        Step.new(
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
      ab_expects: [],
    ).freeze
  end

  def test_step_basic
    moto = @recipe.steps[0]

    assert_equal 20, moto.kojis[0].weight
    assert_equal 0, moto.kojis[0].interval_days

    assert_equal 45, moto.kakes[0].weight
    assert_equal 5, moto.kakes[0].interval_days

    assert_equal 70, moto.waters[0].weight
    assert_in_delta 0.4795, moto.lactic_acids[0].weight
    assert_nil moto.alcohols[0]
    assert_in_delta 0.975, moto.yeasts[0].weight

    assert_equal 65, moto.rice_total
    assert_in_delta 0.3076923076923077, moto.koji_ratio
    assert_in_delta 1.0769230769230769, moto.water_ratio
  end

  def test_step_add
    moto = @recipe.steps[0]
    soe = @recipe.steps[1]
    step = moto + soe

    assert_equal 60, step.kojis[0].weight
    assert_equal 0, step.kojis[0].interval_days

    assert_equal 145, step.kakes[0].weight
    assert_equal 5, step.kakes[0].interval_days

    assert_equal 200, step.waters[0].weight
    assert_in_delta 0.4795, step.lactic_acids[0].weight
    assert_nil step.alcohols[0]
    assert_in_delta 0.975, step.yeasts[0].weight

    assert_equal 205, step.rice_total
    assert_in_delta 0.2926829268292683, step.koji_ratio
    assert_in_delta 0.975609756097561, step.water_ratio
  end

  def test_step_mul
    moto = @recipe.steps[0]
    step = moto * 2

    assert_equal 40, step.kojis[0].weight
    assert_equal 0, step.kojis[0].interval_days

    assert_equal 90, step.kakes[0].weight
    assert_equal 5, step.kakes[0].interval_days

    assert_equal 140, step.waters[0].weight
    assert_in_delta 0.959, step.lactic_acids[0].weight
    assert_nil step.alcohols[0]
    assert_in_delta 1.95, step.yeasts[0].weight

    assert_equal 130, step.rice_total
    assert_in_delta 0.3076923076923077, step.koji_ratio
    assert_in_delta 1.0769230769230769, step.water_ratio
  end

  def test_step_round
    moto = @recipe.steps[0]
    step = (moto * 1.3333333333333333).round

    assert_equal 27, step.kojis[0].weight
    assert_equal 0, step.kojis[0].interval_days

    assert_equal 60, step.kakes[0].weight
    assert_equal 5, step.kakes[0].interval_days

    assert_equal 93, step.waters[0].weight
    assert_in_delta 0.639, step.lactic_acids[0].weight
    assert_nil step.alcohols[0]
    assert_in_delta 1.3, step.yeasts[0].weight

    assert_equal 87, step.rice_total
    assert_in_delta 0.3103448275862069, step.koji_ratio
    assert_in_delta 1.0689655172413792, step.water_ratio
  end

  def test_recipe_basic
    assert_equal 5, @recipe.steps.length

    assert_equal [65.0, 205.0, 480.0, 920.0, 1000.0], @recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3170731707317073, 0.13541666666666666, 0.07065217391304347, 0.065], @recipe.cumulative_moto_ratios

    assert_equal 0.065, @recipe.moto_ratio
    assert_equal [1.0, 2.1538461538461537, 4.230769230769231, 6.769230769230769, 1.2307692307692308], @recipe.rice_ratios
  end

  def test_recipe_scale_rice_total
    recipe = @recipe.scale_rice_total(350)
  
    assert_equal [22.75, 71.75, 168.0, 322.0, 350.0], recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3170731707317073, 0.13541666666666666, 0.07065217391304347, 0.065], recipe.cumulative_moto_ratios

    assert_equal 0.065, recipe.moto_ratio
    assert_equal [1.0, 2.1538461538461537, 4.230769230769231, 6.769230769230769, 1.2307692307692308], recipe.rice_ratios
  end

  def test_recipe_round
    recipe = @recipe.scale_rice_total(350).round
  
    assert_equal [23.0, 72.0, 168.0, 322.0, 350.0], recipe.cumulative_rice_totals
    assert_equal [1.0, 0.3194444444444444, 0.13690476190476192, 0.07142857142857142, 0.06571428571428571], recipe.cumulative_moto_ratios

    assert_equal 0.06571428571428571, recipe.moto_ratio
    assert_equal [1.0, 2.130434782608696, 4.173913043478261, 6.695652173913044, 1.2173913043478262], recipe.rice_ratios
  end
end
