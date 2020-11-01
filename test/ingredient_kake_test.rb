require "test_helper"

class IngredientKakeTest < Minitest::Test
  def setup
    @kake = Kake.new(
      weight: 100,
      brand: :yamadanishiki,
      polishing_ratio: 0.55,
      made_in: :hyogo,
      year: 2020,
      soaking_ratio: 0.33,
      steaming_ratio: 0.41,
      cooling_ratio: 0.33,
      interval_days: 0,
    )
  end

  def test_basic
    assert_equal 100, @kake.weight

    assert_equal :yamadanishiki, @kake.brand
    assert_equal 0.55, @kake.polishing_ratio
    assert_equal :hyogo, @kake.made_in
    assert_equal 2020, @kake.year

    assert_equal 0.33, @kake.soaking_ratio
    assert_equal 133, @kake.soaked

    assert_equal 0.41, @kake.steaming_ratio
    assert_equal 141, @kake.steamed

    assert_equal 0.33, @kake.cooling_ratio
    assert_equal 133, @kake.cooled

    assert_equal 0, @kake.interval_days
  end
end
