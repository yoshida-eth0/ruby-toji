require "test_helper"

class ProgressKojiTest < Minitest::Test
  def setup
    @koji = KojiProgress.new(
      states: [
        KojiState.create({
          time: Time.mktime(2020, 1, 1, 9, 0),
          mark: "引込み",
          temps: 35.0,
          room_dry_temp: 28.0,
        }),
        KojiState.create({
          time: Time.mktime(2020, 1, 1, 10, 0),
          mark: "床揉み",
          temps: 32.0,
          room_dry_temp: 28.0,
        }),
        KojiState.create({
          time: Time.mktime(2020, 1, 1, 19, 0),
          mark: "切返し",
          temps: [32.0, 31.0],
          room_dry_temp: 28.0,
        }),
      ],
    )
  end

  def test_basic
    assert_equal Time.mktime(2020, 1, 1, 9, 0), @koji.base_time
    assert_equal 32400, @koji.day_offset

    states = @koji.states

    assert_equal 3, states.length
    assert_equal 3600, states[1].elapsed_time
  end

  def test_progress
    table_data = @koji.progress_note.table_data

    assert_equal [:day_label, :display_time, :mark, :temps, :room_dry_temp], table_data[:header]
    assert_equal ["1", "01/01 09:00", "引込み", "35.0", "28.0"], table_data[:rows][0]
    assert_equal 3, table_data[:rows].length
  end
end
