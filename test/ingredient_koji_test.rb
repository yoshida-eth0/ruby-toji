require "test_helper"

class IngredientKojiTest < Minitest::Test
  def setup
    @koji = Koji.create(
      raw: 100,
      soaked_rate: 0.33,
      steamed_rate: 0.41,
      cooled_rate: 0.33,
      tanekoji_rate: 0.001,
      dekoji_rate: 0.18,
      interval_days: 0,
    )
  end

  def test_basic
    assert_equal 100, @koji.raw

    assert_equal 0.33, @koji.soaked_rate
    assert_equal 133, @koji.soaked

    assert_equal 0.41, @koji.steamed_rate
    assert_equal 141, @koji.steamed

    assert_equal 0.33, @koji.cooled_rate
    assert_equal 133, @koji.cooled

    assert_equal 0.001, @koji.tanekoji_rate
    assert_equal 0.1, @koji.tanekoji

    assert_equal 0.18, @koji.dekoji_rate
    assert_equal 118, @koji.dekoji
  end
end
