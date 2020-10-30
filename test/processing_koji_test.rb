require "test_helper"

class ProcessingKojiTest < Minitest::Test
  def setup
    @processing = KojiProcessing.new(
      date: Time.mktime(2020, 10, 30),
      expect: Koji.create(
        weight: 50.0,
        brand: :yamadanishiki,
        polishing_ratio: 0.55,
        made_in: :hyogo,
        year: 2020,
        soaking_ratio: 0.33,
        steaming_ratio: 0.41,
        cooling_ratio: 0.33,
        tanekojis: [
          Tanekoji.create(
            brand: :byakuya,
            ratio: 0.001,
          ),
        ],
        dekoji_ratio: 0.18,
        interval_days: nil
      ),
      room_temp: 3.0,
      outside_temp: 3.0,
      rice_water_content: 11.0,
      washing_water_temp: 10.0,
      soaking_water_temp: 10.0,
      soaked_rices: [
        SoakedRice.new(
          weight: 10.0,
          soaking_time: 13*60+15,
          soaked: 13.33,
        ),
        SoakedRice.new(
          weight: 10.0,
          soaking_time: 13*60+0,
          soaked: 13.29,
        ),
        SoakedRice.new(
          weight: 10.0,
          soaking_time: 13*60+5,
          soaked: 13.30,
        ),
        SoakedRice.new(
          weight: 10.0,
          soaking_time: 13*60+5,
          soaked: 13.31,
        ),
        SoakedRice.new(
          weight: 10.12,
          soaking_time: 13*60+5,
          soaked: 13.46,
        ),
      ],
      steamed_rices: [
        SteamedRice.new(
          weight: 17.83,
        ),
        SteamedRice.new(
          weight: 18.35,
        ),
        SteamedRice.new(
          weight: 17.65,
        ),
        SteamedRice.new(
          weight: 16.72,
        ),
      ],
      cooled_rices: [
        CooledRice.new(
          weight: 16.94,
        ),
        CooledRice.new(
          weight: 17.43,
        ),
        CooledRice.new(
          weight: 16.76,
        ),
        CooledRice.new(
          weight: 15.88,
        ),
      ],
      dekojis: [
        Dekoji.new(
          weight: 15.23,
        ),
        Dekoji.new(
          weight: 15.54,
        ),
        Dekoji.new(
          weight: 15.02,
        ),
        Dekoji.new(
          weight: 13.17,
        ),
      ],
    )
  end

  def test_basic
    assert_equal Time.mktime(2020, 10, 30), @processing.date

    assert_equal 50, @processing.expect.weight

    assert_equal :yamadanishiki, @processing.expect.brand
    assert_equal 0.55, @processing.expect.polishing_ratio
    assert_equal :hyogo, @processing.expect.made_in
    assert_equal 2020, @processing.expect.year

    assert_equal 0.33, @processing.expect.soaking_ratio
    assert_equal 66.5, @processing.expect.soaked

    assert_equal 0.41, @processing.expect.steaming_ratio
    assert_equal 70.5, @processing.expect.steamed

    assert_equal 0.33, @processing.expect.cooling_ratio
    assert_equal 66.5, @processing.expect.cooled

    tanekoji = @processing.expect.tanekojis.first

    assert_equal :byakuya, tanekoji.brand

    assert_equal 0.001, tanekoji.ratio
    assert_equal 0.05, tanekoji.weight

    assert_equal 0.18, @processing.expect.dekoji_ratio
    assert_equal 59, @processing.expect.dekoji

    assert_nil @processing.expect.interval_days

    assert_equal 3.0, @processing.room_temp
    assert_equal 3.0, @processing.outside_temp
    assert_equal 11.0, @processing.rice_water_content
    assert_equal 10.0, @processing.washing_water_temp
    assert_equal 10.0, @processing.soaking_water_temp
  end

  def test_soaked_rices
    assert_equal 50.12, @processing.weight_total
    assert_equal 66.69, @processing.soaked_total
    assert_in_delta 0.3306065442936952, @processing.soaking_ratio
    assert_in_delta 0.0013530578889090305, @processing.soaking_ratio_sd
  end

  def test_steamed_rices
    assert_equal 70.55, @processing.steamed_total
    assert_in_delta 0.4076217079010375, @processing.steaming_ratio
  end

  def test_cooled_rices
    assert_equal 67.01, @processing.cooled_total
    assert_in_delta 0.3369912210694335, @processing.cooling_ratio
  end

  def test_dekojis
    assert_equal 58.96, @processing.dekoji_total
    assert_in_delta 0.17637669592976862, @processing.dekoji_ratio
  end
end
