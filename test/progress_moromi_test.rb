require "test_helper"

class ProgressMoromiTest < Minitest::Test
  def setup
    @moromi = MoromiProgress.new
  end

  def test_basic
    assert_equal Time.mktime(2020, 1, 16), @moromi.base_time
    assert_equal 0, @moromi.day_offset

    states = @moromi.states

    assert_equal 6, states.length
    assert_equal 691200, states[1].elapsed_time
  end

  def test_progress
    table_data = @moromi.progress_note.table_data

    assert_equal [:day_label, :display_time, :mark, :temps, :room_dry_temp, :display_baume, :alcohol, :bmd], table_data[:header]
    assert_equal ["添", "01/16 00:00", "添", "14.8, 11.0", "9", "", "", ""], table_data[:rows][0]
    assert_equal ["6", "01/25 00:00", "", "13.1", "8", "7.2", "6.75", "43.2"], table_data[:rows][2]
    assert_equal 6, table_data[:rows].length
  end

  def test_bmd
    bmd = @moromi.bmd
    y = bmd.plot_data[0][:y]

    assert_equal 21, bmd.max_moromi_day
    assert_equal 4, y.length
    assert_operator y[0], :<, y[1]
    assert_operator y[1], :>, y[2]
    assert_operator y[2], :>, y[3]
  end

  def test_ab
    ab = @moromi.ab(1.4)
    y = ab.plot_data[0][:y]

    assert_equal 4, y.length
    assert_operator y[0], :>, y[1]
    assert_operator y[1], :>, y[2]
    assert_operator y[2], :>, y[3]
  end
end
