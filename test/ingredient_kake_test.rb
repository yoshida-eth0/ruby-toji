require "test_helper"

class IngredientKakeTest < Minitest::Test
  def setup
    @kake = Kake.create(
      raw: 100,
      soaked_rate: 0.33,
      steamed_rate: 0.41,
      cooled_rate: 0.33,
      interval_days: 0,
    )
  end

  def test_basic
    assert_equal 100, @kake.raw

    assert_equal 0.33, @kake.soaked_rate
    assert_equal 133, @kake.soaked

    assert_equal 0.41, @kake.steamed_rate
    assert_equal 141, @kake.steamed

    assert_equal 0.33, @kake.cooled_rate
    assert_equal 133, @kake.cooled
  end
end
