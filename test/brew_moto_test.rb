require "test_helper"

class BrewMotoTest < Minitest::Test
  class State
    include Toji::Brew::State

    def self.create(val)
      s = new
      KEYS.each {|k|
        if val.has_key?(k)
          s.send("#{k}=", val[k])
        end
      }
      s
    end
  end

  class Moto
    include Toji::Brew::Moto

    def states
      [
        State.create({
          time: Time.mktime(2020, 1, 1),
          mark: "水麹",
          temps: 12.0,
          acid: 13.0,
        }),
        State.create({
          time: Time.mktime(2020, 1, 1, 1, 0),
          mark: "仕込み",
          temps: 20.0,
          acid: 13.0,
        }),
        State.create({
          time: Time.mktime(2020, 1, 2),
          mark: "打瀬",
          temps: 14.0,
          baume: 15.0,
          acid: 13.0,
        }),
      ]
    end

    def base_time
      states.first.time
    end

    def day_offset
      (base_time - Time.mktime(base_time.year, base_time.month, base_time.day)).to_i
    end

    def wrapped_states
      states.map {|s|
        w = Toji::Brew::WrappedState.new(s, self)
        w.elapsed_time = (s.time - base_time).to_i
        w
      }
    end
  end

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
