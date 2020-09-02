require "test_helper"

class BrewMoromiTest < Minitest::Test
  class State
    include Toji::Brew::State
    include Toji::Brew::State::BaumeToNihonshudo

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

  class Moromi
    include Toji::Brew::Moromi

    def prefix_day_labels
      ["添", "踊", "踊", "仲", "留"]
    end

    def states
      [
        State.create({
          time: Time.mktime(2020, 1, 16),
          mark: "添",
          temps: [14.8, 11.0],
          room_temp: 9,
        }),
        State.create({
          time: Time.mktime(2020, 1, 24),
          temps: 12.3,
          room_temp: 8,
          baume: 8.0,
          alcohol: 4.8,
        }),
        State.create({
          time: Time.mktime(2020, 1, 25),
          temps: 13.1,
          room_temp: 8,
          baume: 7.2,
          alcohol: 6.75,
        }),
        State.create({
          time: Time.mktime(2020, 1, 31),
          temps: 12.0,
          room_temp: 7,
          nihonshudo: -21,
          alcohol: 13.7,
        }),
        State.create({
          time: Time.mktime(2020, 2, 6),
          temps: 8.4,
          room_temp: 5,
          nihonshudo: -3,
          alcohol: 16.3,
        }),
        State.create({
          time: Time.mktime(2020, 2, 9),
          temps: 8.1,
          room_temp: 6,
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
    @moromi = Moromi.new
  end

  def test_basic
    assert_equal Time.mktime(2020, 1, 16), @moromi.base_time
    assert_equal 0, @moromi.day_offset

    states = @moromi.wrapped_states

    assert_equal 6, states.length
    assert_equal 691200, states[1].elapsed_time
  end

  def test_progress
    table_data = @moromi.progress.table_data

    assert_equal [:day_label, :display_time, :mark, :temps, :room_temp, :display_baume, :alcohol, :bmd], table_data[:header]
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
