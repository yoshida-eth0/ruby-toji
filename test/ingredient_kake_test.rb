require "test_helper"

class IngredientKakeTest < Minitest::Test
  def setup
    @expected = Toji::Ingredient::Kake.expected(100, rice_rate: Toji::Ingredient::RiceRate::DEFAULT)
    @actual = Toji::Ingredient::Kake.actual(100, 133, 141, 133)
  end

  def test_expected_basic
    assert_equal 100, @expected.raw

    assert_equal 0.33, @expected.soaked_rate
    assert_equal 33, @expected.soaking_water
    assert_equal 133, @expected.soaked

    assert_equal 0.41, @expected.steamed_rate
    assert_equal 41, @expected.steaming_water
    assert_equal 141, @expected.steamed

    assert_equal 0.33, @expected.cooled_rate
    assert_equal 133, @expected.cooled
  end

  def test_expected_add
    kake = @expected + @expected

    assert_equal 200, kake.raw

    assert_equal 0.33, kake.soaked_rate
    assert_equal 66, kake.soaking_water
    assert_equal 266, kake.soaked

    assert_equal 0.41, kake.steamed_rate
    assert_equal 82, kake.steaming_water
    assert_equal 282, kake.steamed

    assert_equal 0.33, kake.cooled_rate
    assert_equal 266, kake.cooled
  end

  def test_expected_mul
    kake = @expected * 2

    assert_equal 200, kake.raw

    assert_equal 0.33, kake.soaked_rate
    assert_equal 66, kake.soaking_water
    assert_equal 266, kake.soaked

    assert_equal 0.41, kake.steamed_rate
    assert_equal 82, kake.steaming_water
    assert_equal 282, kake.steamed

    assert_equal 0.33, kake.cooled_rate
    assert_equal 266, kake.cooled
  end

  def test_actual_basic
    assert_equal 100, @actual.raw

    assert_equal 0.33, @actual.soaked_rate
    assert_equal 33, @actual.soaking_water
    assert_equal 133, @actual.soaked

    assert_equal 0.41, @actual.steamed_rate
    assert_equal 41, @actual.steaming_water
    assert_equal 141, @actual.steamed

    assert_equal 0.33, @actual.cooled_rate
    assert_equal 133, @actual.cooled
  end

  def test_actual_add
    kake = @actual + @actual

    assert_equal 200, kake.raw

    assert_equal 0.33, kake.soaked_rate
    assert_equal 66, kake.soaking_water
    assert_equal 266, kake.soaked

    assert_equal 0.41, kake.steamed_rate
    assert_equal 82, kake.steaming_water
    assert_equal 282, kake.steamed

    assert_equal 0.33, kake.cooled_rate
    assert_equal 266, kake.cooled
  end

  def test_actual_mul
    kake = @actual * 2

    assert_equal 200, kake.raw

    assert_equal 0.33, kake.soaked_rate
    assert_equal 66, kake.soaking_water
    assert_equal 266, kake.soaked

    assert_equal 0.41, kake.steamed_rate
    assert_equal 82, kake.steaming_water
    assert_equal 282, kake.steamed

    assert_equal 0.33, kake.cooled_rate
    assert_equal 266, kake.cooled
  end
end
