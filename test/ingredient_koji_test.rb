require "test_helper"

class IngredientKojiTest < Minitest::Test
  def setup
    @koji = Koji.create(
      raw: 100,
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
    )
  end

  def test_basic
    assert_equal 100, @koji.raw

    assert_equal :yamadanishiki, @koji.brand
    assert_equal :hyogo, @koji.made_in
    assert_equal 2020, @koji.year

    assert_equal 0.33, @koji.soaked_rate
    assert_equal 133, @koji.soaked

    assert_equal 0.41, @koji.steamed_rate
    assert_equal 141, @koji.steamed

    assert_equal 0.33, @koji.cooled_rate
    assert_equal 133, @koji.cooled

    assert_equal :byakuya, @koji.tanekoji_brand

    assert_equal 0.001, @koji.tanekoji_rate
    assert_equal 0.1, @koji.tanekoji

    assert_equal 0.18, @koji.dekoji_rate
    assert_equal 118, @koji.dekoji

    assert_equal 0, @koji.interval_days
  end
end
