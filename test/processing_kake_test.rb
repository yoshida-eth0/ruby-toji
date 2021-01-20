require "test_helper"

class ProcessingKakeTest < Minitest::Test
  def setup
    @processing = KakeProcessing.new(
      date: Time.mktime(2020, 10, 30),
      expect: Kake.new(
        weight: 50.0,
        brand: :yamadanishiki,
        polishing_ratio: 0.55,
        made_in: :hyogo,
        farmer: :tanaka,
        rice_year: 2020,
        soaking_ratio: 0.33,
        steaming_ratio: 0.41,
        cooling_ratio: 0.33,
        interval_days: nil
      ),
      soaked_rice: SoakedRice.new(
        room_temp: 3.0,
        outside_temp: 3.0,
        rice_water_content: 11.0,
        washing_water_temp: 10.0,
        soaking_water_temp: 10.0,
        elements: [
          SoakedRiceElement.new(
            weight: 10.0,
            soaking_time: 13*60+15,
            soaked: 13.33,
          ),
          SoakedRiceElement.new(
            weight: 10.0,
            soaking_time: 13*60+0,
            soaked: 13.29,
          ),
          SoakedRiceElement.new(
            weight: 10.0,
            soaking_time: 13*60+5,
            soaked: 13.30,
          ),
          SoakedRiceElement.new(
            weight: 10.0,
            soaking_time: 13*60+5,
            soaked: 13.31,
          ),
          SoakedRiceElement.new(
            weight: 10.12,
            soaking_time: 13*60+5,
            soaked: 13.46,
          ),
        ],
      ),
      steamed_rice: SteamedRice.new(
        elements: [
          SteamedRiceElement.new(
            weight: 17.83,
          ),
          SteamedRiceElement.new(
            weight: 18.35,
          ),
          SteamedRiceElement.new(
            weight: 17.65,
          ),
          SteamedRiceElement.new(
            weight: 16.72,
          ),
        ],
      ),
      cooled_rice: CooledRice.new(
        elements: [
          CooledRiceElement.new(
            weight: 16.94,
          ),
          CooledRiceElement.new(
            weight: 17.43,
          ),
          CooledRiceElement.new(
            weight: 16.76,
          ),
          CooledRiceElement.new(
            weight: 15.88,
          ),
        ],
      ),
    )
  end

  def test_basic
    assert_equal Time.mktime(2020, 10, 30), @processing.date

    assert_equal 50, @processing.expect.weight

    assert_equal :yamadanishiki, @processing.expect.brand
    assert_equal 0.55, @processing.expect.polishing_ratio
    assert_equal :hyogo, @processing.expect.made_in
    assert_equal :tanaka, @processing.expect.farmer
    assert_equal 2020, @processing.expect.rice_year

    assert_equal 0.33, @processing.expect.soaking_ratio
    assert_equal 66.5, @processing.expect.soaked

    assert_equal 0.41, @processing.expect.steaming_ratio
    assert_equal 70.5, @processing.expect.steamed

    assert_equal 0.33, @processing.expect.cooling_ratio
    assert_equal 66.5, @processing.expect.cooled

    assert_nil @processing.expect.interval_days
  end

  def test_soaked_rice
    assert_equal 3.0, @processing.soaked_rice.room_temp
    assert_equal 3.0, @processing.soaked_rice.outside_temp
    assert_equal 11.0, @processing.soaked_rice.rice_water_content
    assert_equal 10.0, @processing.soaked_rice.washing_water_temp
    assert_equal 10.0, @processing.soaked_rice.soaking_water_temp

    assert_equal 50.12, @processing.soaked_rice.weight
    assert_equal 66.69, @processing.soaked_rice.soaked
    assert_in_delta 0.3306065442936952, @processing.soaked_rice.soaking_ratio
    assert_in_delta 0.0013530578889090305, @processing.soaked_rice.soaking_ratio_sd
  end

  def test_steamed_rice
    assert_equal 70.55, @processing.steamed_rice.weight
    assert_in_delta 0.4076217079010375, @processing.steamed_rice.steaming_ratio
  end

  def test_cooled_rice
    assert_equal 67.01, @processing.cooled_rice.weight
    assert_in_delta 0.3369912210694335, @processing.cooled_rice.cooling_ratio
  end
end
