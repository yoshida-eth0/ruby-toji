require "test_helper"

class IngredientKojiTest < Minitest::Test
  def setup
    @expected = Toji::Ingredient::Koji.expected(100, rice_rate: Toji::Ingredient::RiceRate::DEFAULT, koji_rate: Toji::Ingredient::KojiRate::DEFAULT)
    @actual = Toji::Ingredient::Koji.actual(100, 133, 141, 133, 0.1, 118)
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

    assert_equal 0.001, @expected.tanekoji_rate
    assert_equal 0.1, @expected.tanekoji

    assert_equal 0.18, @expected.dekoji_rate
    assert_equal 118, @expected.dekoji
  end

  def test_expected_add
    koji = @expected + @expected

    assert_equal 200, koji.raw

    assert_equal 0.33, koji.soaked_rate
    assert_equal 66, koji.soaking_water
    assert_equal 266, koji.soaked

    assert_equal 0.41, koji.steamed_rate
    assert_equal 82, koji.steaming_water
    assert_equal 282, koji.steamed

    assert_equal 0.33, koji.cooled_rate
    assert_equal 266, koji.cooled

    assert_equal 0.001, koji.tanekoji_rate
    assert_equal 0.2, koji.tanekoji

    assert_equal 0.18, koji.dekoji_rate
    assert_equal 236, koji.dekoji
  end

  def test_expected_mul
    koji = @expected * 2

    assert_equal 200, koji.raw

    assert_equal 0.33, koji.soaked_rate
    assert_equal 66, koji.soaking_water
    assert_equal 266, koji.soaked

    assert_equal 0.41, koji.steamed_rate
    assert_equal 82, koji.steaming_water
    assert_equal 282, koji.steamed

    assert_equal 0.33, koji.cooled_rate
    assert_equal 266, koji.cooled

    assert_equal 0.001, koji.tanekoji_rate
    assert_equal 0.2, koji.tanekoji

    assert_equal 0.18, koji.dekoji_rate
    assert_equal 236, koji.dekoji
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

    assert_equal 0.001, @actual.tanekoji_rate
    assert_equal 0.1, @actual.tanekoji

    assert_equal 0.18, @actual.dekoji_rate
    assert_equal 118, @actual.dekoji
  end

  def test_actual_add
    koji = @actual + @actual

    assert_equal 200, koji.raw

    assert_equal 0.33, koji.soaked_rate
    assert_equal 66, koji.soaking_water
    assert_equal 266, koji.soaked

    assert_equal 0.41, koji.steamed_rate
    assert_equal 82, koji.steaming_water
    assert_equal 282, koji.steamed

    assert_equal 0.33, koji.cooled_rate
    assert_equal 266, koji.cooled

    assert_equal 0.001, koji.tanekoji_rate
    assert_equal 0.2, koji.tanekoji

    assert_equal 0.18, koji.dekoji_rate
    assert_equal 236, koji.dekoji
  end

  def test_actual_mul
    koji = @actual * 2

    assert_equal 200, koji.raw

    assert_equal 0.33, koji.soaked_rate
    assert_equal 66, koji.soaking_water
    assert_equal 266, koji.soaked

    assert_equal 0.41, koji.steamed_rate
    assert_equal 82, koji.steaming_water
    assert_equal 282, koji.steamed

    assert_equal 0.33, koji.cooled_rate
    assert_equal 266, koji.cooled

    assert_equal 0.001, koji.tanekoji_rate
    assert_equal 0.2, koji.tanekoji

    assert_equal 0.18, koji.dekoji_rate
    assert_equal 236, koji.dekoji
  end
end
