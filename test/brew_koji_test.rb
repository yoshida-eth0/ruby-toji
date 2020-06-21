require "test_helper"

class BrewKojiTest < Minitest::Test
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

  class Koji
    include Toji::Brew::Koji

    def states
      [
        State.create({
          time: Time.mktime(2020, 1, 1, 9, 0),
          mark: "引込み",
          temps: 35.0,
          room_temp: 28.0,
        }),
        State.create({
          time: Time.mktime(2020, 1, 1, 10, 0),
          mark: "床揉み",
          temps: 32.0,
          room_temp: 28.0,
        }),
        State.create({
          time: Time.mktime(2020, 1, 1, 19, 0),
          mark: "切返し",
          temps: [32.0, 31.0],
          room_temp: 28.0,
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
    @koji = Koji.new
  end

  def test_basic
    assert_equal Time.mktime(2020, 1, 1, 9, 0), @koji.base_time
    assert_equal 32400, @koji.day_offset

    states = @koji.wrapped_states

    assert_equal 3, states.length
    assert_equal 3600, states[1].elapsed_time
  end

  def test_progress
    table_data = @koji.progress.table_data

    assert_equal [:day_label, :display_time, :mark, :temps, :room_temp], table_data[:header]
    assert_equal ["1", "01/01 09:00", "引込み", "35.0", "28.0"], table_data[:rows][0]
    assert_equal 3, table_data[:rows].length
  end
end
