require "test_helper"

class ProductTest < Minitest::Test
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
            tanekojis: [
              Tanekoji.create(
                brand: :byakuya,
                rate: 0.001,
              ),
            ],
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
            tanekojis: [
              Tanekoji.create(
                brand: :byakuya,
                rate: 0.001,
              ),
            ],
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
            tanekojis: [
              Tanekoji.create(
                brand: :byakuya,
                rate: 0.001,
              ),
            ],
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
            tanekojis: [
              Tanekoji.create(
                brand: :byakuya,
                rate: 0.001,
              ),
            ],
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
