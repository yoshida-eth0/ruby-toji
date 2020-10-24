$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "toji"

class Product
  include Toji::Product
  include Toji::Product::EventFactory

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

  def initialize_copy(obj)
    self.koji = obj.koji.dup
    self.kake = obj.kake.dup
    self.water = obj.water.dup
    self.lactic_acid = obj.lactic_acid
    self.alcohol = obj.alcohol
    self.yeast = obj.yeast
  end

  def self.create(koji: nil, kake: nil, water: nil, lactic_acid: nil, alcohol: nil, yeast: nil)
    new.tap {|o|
      o.koji = koji
      o.kake = kake
      o.water = water
      o.lactic_acid = lactic_acid
      o.alcohol = alcohol
      o.yeast = yeast
    }
  end
end

class Koji
  include Toji::Ingredient::Koji

  attr_accessor :raw
  attr_accessor :soaked_rate
  attr_accessor :steamed_rate
  attr_accessor :cooled_rate
  attr_accessor :tanekoji_rate
  attr_accessor :dekoji_rate
  attr_accessor :interval_days

  def self.create(raw:, brand:, made_in:, year:, soaked_rate:, steamed_rate:, cooled_rate:, tanekoji_brand:, tanekoji_rate:, dekoji_rate:, interval_days:)
    new.tap {|o|
      o.raw = raw
      o.brand = brand
      o.made_in = made_in
      o.year = year
      o.soaked_rate = soaked_rate
      o.steamed_rate = steamed_rate
      o.cooled_rate = cooled_rate
      o.tanekoji_brand = tanekoji_brand
      o.tanekoji_rate = tanekoji_rate
      o.dekoji_rate = dekoji_rate
      o.interval_days = interval_days
    }
  end
end

class Kake
  include Toji::Ingredient::Kake

  attr_accessor :raw
  attr_accessor :soaked_rate
  attr_accessor :steamed_rate
  attr_accessor :cooled_rate
  attr_accessor :interval_days

  def self.create(raw:, brand:, made_in:, year:, soaked_rate:, steamed_rate:, cooled_rate:, interval_days:)
    new.tap {|o|
      o.raw = raw
      o.brand = brand
      o.made_in = made_in
      o.year = year
      o.soaked_rate = soaked_rate
      o.steamed_rate = steamed_rate
      o.cooled_rate = cooled_rate
      o.interval_days = interval_days
    }
  end
end

class Water
  include Toji::Ingredient::Water

  attr_accessor :weight

  def self.create(weight:)
    new.tap {|o|
      o.weight = weight
    }
  end
end

class LacticAcid
  include Toji::Ingredient::LacticAcid

  attr_accessor :weight

  def self.create(weight:)
    new.tap {|o|
      o.weight = weight
    }
  end
end

class Alcohol
  include Toji::Ingredient::Alcohol

  attr_accessor :weight

  def self.create(weight:)
    new.tap {|o|
      o.weight = weight
    }
  end
end

class Yeast
  include Toji::Ingredient::Yeast

  attr_accessor :weight

  def self.create(weight:)
    new.tap {|o|
      o.weight = weight
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
  include Toji::Brew::KojiProgress

  def states
    [
      KojiState.create({
        progress: self,
        time: Time.mktime(2020, 1, 1, 9, 0),
        mark: "引込み",
        temps: 35.0,
        room_temp: 28.0,
      }),
      KojiState.create({
        progress: self,
        time: Time.mktime(2020, 1, 1, 10, 0),
        mark: "床揉み",
        temps: 32.0,
        room_temp: 28.0,
      }),
      KojiState.create({
        progress: self,
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
end

class KojiState
  include Toji::Brew::KojiState

  KEYS = [
    :progress,
    :time,
    :mark,
    :temps,
    :preset_temp,
    :room_temp,
    :room_psychrometry,
    :note,
  ]

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


class MotoProgress
  include Toji::Brew::MotoProgress

  def states
    [
      MotoState.create({
        progress: self,
        time: Time.mktime(2020, 1, 1),
        mark: "水麹",
        temps: 12.0,
        acid: 13.0,
      }),
      MotoState.create({
        progress: self,
        time: Time.mktime(2020, 1, 1, 1, 0),
        mark: "仕込み",
        temps: 20.0,
        acid: 13.0,
      }),
      MotoState.create({
        progress: self,
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
end

class MotoState
  include Toji::Brew::MotoState

  KEYS = [
    :progress,
    :time,
    :mark,
    :temps,
    :preset_temp,
    :room_temp,
    :room_psychrometry,
    :baume,
    :acid,
    :warmings,
    :note,
  ]

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


class MoromiProgress
  include Toji::Brew::MoromiProgress

  def prefix_day_labels
    ["添", "踊", "踊", "仲", "留"]
  end

  def states
    [
      MoromiState.create({
        progress: self,
        time: Time.mktime(2020, 1, 16),
        mark: "添",
        temps: [14.8, 11.0],
        room_temp: 9,
      }),
      MoromiState.create({
        progress: self,
        time: Time.mktime(2020, 1, 24),
        temps: 12.3,
        room_temp: 8,
        baume: 8.0,
        alcohol: 4.8,
      }),
      MoromiState.create({
        progress: self,
        time: Time.mktime(2020, 1, 25),
        temps: 13.1,
        room_temp: 8,
        baume: 7.2,
        alcohol: 6.75,
      }),
      MoromiState.create({
        progress: self,
        time: Time.mktime(2020, 1, 31),
        temps: 12.0,
        room_temp: 7,
        nihonshudo: -21,
        alcohol: 13.7,
      }),
      MoromiState.create({
        progress: self,
        time: Time.mktime(2020, 2, 6),
        temps: 8.4,
        room_temp: 5,
        nihonshudo: -3,
        alcohol: 16.3,
      }),
      MoromiState.create({
        progress: self,
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
end

class MoromiState
  include Toji::Brew::MoromiState
  include Toji::Brew::State::BaumeToNihonshudo

  KEYS = [
    :progress,
    :time,
    :mark,
    :temps,
    :preset_temp,
    :room_temp,
    :room_psychrometry,
    :baume,
    :nihonshudo,
    :acid,
    :amino_acid,
    :alcohol,
    :warmings,
    :note,
  ]

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


require "minitest/autorun"
