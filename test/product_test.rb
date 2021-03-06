require "test_helper"

class ProductTest < Minitest::Test
  def setup
    # 酒造教本による標準型仕込配合
    # 出典: 酒造教本 P97
    @recipe = Recipe.new(
      steps: [
        Step.new(
          index: 0,
          subindex: 0,
          interval_days: 5,
          kojis: [
            Koji.new(
              weight: 20,
              brand: :yamadanishiki,
              polishing_ratio: 0.55,
              made_in: :hyogo,
              farmer: :tanaka,
              rice_year: 2020,
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
              interval_days: 1,
            ),
          ],
          kakes: [
            Kake.new(
              weight: 45,
              brand: :yamadanishiki,
              polishing_ratio: 0.55,
              made_in: :hyogo,
              farmer: :tanaka,
              rice_year: 2020,
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
          index: 1,
          subindex: 0,
          interval_days: 20,
          kojis: [
            Koji.new(
              weight: 40,
              brand: :yamadanishiki,
              polishing_ratio: 0.55,
              made_in: :hyogo,
              farmer: :tanaka,
              rice_year: 2020,
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
              farmer: :tanaka,
              rice_year: 2020,
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
          interval_days: 22,
          kojis: [
            Koji.new(
              weight: 60,
              brand: :yamadanishiki,
              polishing_ratio: 0.55,
              made_in: :hyogo,
              farmer: :tanaka,
              rice_year: 2020,
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
              farmer: :tanaka,
              rice_year: 2020,
              soaking_ratio: 0.33,
              steaming_ratio: 0.41,
              cooling_ratio: 0.33,
              interval_days: 22,
              process_group: "process1"
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
          interval_days: 23,
          kojis: [
            Koji.new(
              weight: 80,
              brand: :yamadanishiki,
              polishing_ratio: 0.55,
              made_in: :hyogo,
              farmer: :tanaka,
              rice_year: 2020,
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
              farmer: :tanaka,
              rice_year: 2020,
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
          interval_days: 40,
          kakes: [
            Kake.new(
              weight: 80,
              brand: :yamadanishiki,
              polishing_ratio: 0.55,
              made_in: :hyogo,
              farmer: :tanaka,
              rice_year: 2020,
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

    @product = Product.new("仕1", @recipe, Time.mktime(2020, 2, 10))
  end

  def test_basic
    assert_equal "仕1", @product.serial_num
    assert_equal @recipe, @product.recipe
    assert_equal Time.mktime(2020, 2, 10), @product.base_date
  end

  def test_rice_schedules
    rice_schedules = @product.rice_schedules
    schedule1 = rice_schedules[1]
    schedule4 = rice_schedules[4]

    assert_equal 7, rice_schedules.length

    assert_equal Time.mktime(2020, 2, 24), schedule1.date
    assert_equal "Koji:20200224:yamadanishiki:0.55:hyogo:tanaka:2020:0.33:0.41:0.33:0.18:byakuya:0.001:", schedule1.group_key
    assert_equal :koji, schedule1.rice_type
    assert_equal 180, schedule1.expect.weight
    assert_equal [{index: 1, subindex: 0, weight: 40}, {index: 2, subindex: 0, weight: 60}, {index: 3, subindex: 0, weight: 80}], schedule1.step_weights

    assert_equal Time.mktime(2020, 3, 3), schedule4.date
    assert_equal "Kake:20200303:yamadanishiki:0.55:hyogo:tanaka:2020:0.33:0.41:0.33:process1", schedule4.group_key
    assert_equal :kake, schedule4.rice_type
    assert_equal 215, schedule4.expect.weight
    assert_equal [{index: 2, subindex: 0, weight: 215}], schedule4.step_weights
  end

  def test_compact
    compact_product = @product.compact

    assert_equal Time.mktime(2020, 2, 10), @product.base_date
    assert_equal Time.mktime(2020, 2, 11), compact_product.base_date

    assert_equal 5, @product.recipe.steps[0].interval_days
    assert_equal 4, compact_product.recipe.steps[0].interval_days

    assert_equal 1, @product.recipe.steps[0].kojis[0].interval_days
    assert_equal 0, compact_product.recipe.steps[0].kojis[0].interval_days

    assert_equal 50, @product.recipe.max_interval_days
    assert_equal 49, compact_product.recipe.max_interval_days

    rice_schedules = compact_product.rice_schedules
    schedule1 = rice_schedules[1]
    schedule4 = rice_schedules[4]

    assert_equal Time.mktime(2020, 2, 24), schedule1.date
    assert_equal Time.mktime(2020, 3, 3), schedule4.date
  end
end
