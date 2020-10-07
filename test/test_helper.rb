$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "toji"

class Product
  include Toji::Product
  include Toji::Product::EventFactory

  attr_accessor :description
  attr_accessor :color

  def initialize(name, recipe, base_date)
    @name = name
    @recipe = recipe
    @base_date = base_date
  end

  def create_koji_event(date:, index:, step_indexes:, raw:)
    KojiEvent.new(product: self, date: date, index: index, step_indexes: step_indexes, raw: raw)
  end

  def create_kake_event(date:, index:, step_indexes:, raw:)
    KakeEvent.new(product: self, date: date, index: index, step_indexes: step_indexes, raw: raw)
  end

  def create_action_event(date:, type:, index:)
    ActionEvent.new(product: self, date: date, type: type, index: index)
  end
end

class Recipe
  include Toji::Recipe

  def initialize
    @steps = []
  end

  def self.create(steps, actions, has_moto, has_moromi, ab_coef, ab_expects)
    new.tap {|o|
      o.steps = steps
      o.actions = actions
      o.has_moto = has_moto
      o.has_moromi = has_moromi
      o.ab_coef = ab_coef
      o.ab_expects = ab_expects
    }
  end
end

class Step
  include Toji::Recipe::Step

  def self.create(koji: 0, koji_interval_days: 0, kake: 0, kake_interval_days: 0, water: 0, lactic_acid: 0, alcohol: 0, yeast: 0)
    new.tap {|o|
      o.koji = koji.to_f
      o.koji_soaked_rate = 0.0
      o.koji_steamed_rate = 0.0
      o.koji_dekoji_rate = 0.0
      o.koji_interval_days = koji_interval_days.to_i

      o.kake = kake.to_f
      o.kake_soaked_rate = 0.0
      o.kake_steamed_rate = 0.0
      o.kake_interval_days = kake_interval_days.to_i

      o.water = water.to_f
      o.lactic_acid = lactic_acid.to_f
      o.alcohol = alcohol.to_f
      o.yeast = yeast.to_f
    }
  end
end

class Action
  include Toji::Recipe::Action

  def self.create(type:, interval_days:)
    new.tap {|o|
      o.type = type
      o.interval_days = interval_days
    }
  end
end

class KojiEvent
  include Toji::Event::KojiEvent

  def initialize(product:, date:, index:, step_indexes:, raw:)
    @product = product
    @date = date
    @index = index
    @step_indexes = step_indexes
    @raw = raw
  end
end

class KakeEvent
  include Toji::Event::KakeEvent

  def initialize(product:, date:, index:, step_indexes:, raw:)
    @product = product
    @date = date
    @index = index
    @step_indexes = step_indexes
    @raw = raw
  end
end

class ActionEvent
  include Toji::Event::ActionEvent

  def initialize(product:, date:, type:, index:)
    @product = product
    @date = date
    @type = type
    @index = index
  end
end


class KojiProgress
  # TODO
end

class KojiProgressState
  # TODO
end

class MotoProgress
  # TODO
end

class MotoProgressState
  # TODO
end

class MoromiProgress
  # TODO
end

class MoromiProgressState
  # TODO
end

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


require "minitest/autorun"
