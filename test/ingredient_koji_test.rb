require "test_helper"

class IngredientKojiTest < Minitest::Test
  def setup
    @koji = Koji.new(
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
    )
  end

  def test_basic
    assert_equal 100, @koji.weight

    assert_equal :yamadanishiki, @koji.brand
    assert_equal 0.55, @koji.polishing_ratio
    assert_equal :hyogo, @koji.made_in
    assert_equal 2020, @koji.year

    assert_equal 0.33, @koji.soaking_ratio
    assert_equal 133, @koji.soaked

    assert_equal 0.41, @koji.steaming_ratio
    assert_equal 141, @koji.steamed

    assert_equal 0.33, @koji.cooling_ratio
    assert_equal 133, @koji.cooled

    tanekoji = @koji.tanekojis.first

    assert_equal :byakuya, tanekoji.brand

    assert_equal 0.001, tanekoji.ratio
    assert_equal 0.1, tanekoji.weight

    assert_equal 0.18, @koji.dekoji_ratio
    assert_equal 118, @koji.dekoji

    assert_equal 0, @koji.interval_days
  end
end
