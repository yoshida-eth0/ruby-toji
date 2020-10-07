require "test_helper"

class BrewMotoTest < Minitest::Test
  def setup
    @moto = Moto.new
  end

  def test_basic
    assert_equal Time.mktime(2020, 1, 1), @moto.base_time
    assert_equal 0, @moto.day_offset

    states = @moto.wrapped_states

    assert_equal 3, states.length
    assert_equal 3600, states[1].elapsed_time
  end

  def test_progress
    table_data = @moto.progress.table_data

    assert_equal [:day_label, :display_time, :mark, :temps, :display_baume, :acid], table_data[:header]
    assert_equal ["1", "01/01 00:00", "水麹", "12.0", "", "13.0"], table_data[:rows][0]
    assert_equal 3, table_data[:rows].length
  end
end
