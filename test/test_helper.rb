$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "toji"

class Product
  include Toji::Product
  include Toji::Product::ScheduleFactory

  def initialize(name, recipe, base_date)
    @name = name
    @recipe = recipe
    @base_date = base_date
  end

  def create_koji_schedule(date:, step_indexes:, kojis:)
    expect = kojis.first.dup
    expect.weight = kojis.map(&:weight).sum

    KojiSchedule.new(
      product: self,
      date: date,
      step_indexes: step_indexes,
      expect: expect,
    )
  end

  def create_kake_schedule(date:, step_indexes:, kakes:)
    expect = kakes.first.dup
    expect.weight = kakes.map(&:weight).sum

    KakeSchedule.new(
      product: self,
      date: date,
      step_indexes: step_indexes,
      expect: expect,
    )
  end

  def create_action_schedule(date:, action_index:, action:)
    ActionSchedule.new(
      product: self,
      date: date,
      type: action.type,
      action_index: index,
    )
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
    self.kojis = obj.kojis&.map(&:dup) || []
    self.kakes = obj.kakes&.map(&:dup) || []
    self.waters = obj.waters&.map(&:dup) || []
    self.lactic_acids = obj.lactic_acids&.map(&:dup) || []
    self.alcohols = obj.alcohols&.map(&:dup) || []
    self.yeasts = obj.yeasts&.map(&:dup) || []
  end

  def self.create(kojis: [], kakes: [], waters: [], lactic_acids: [], alcohols: [], yeasts: [])
    new.tap {|o|
      o.kojis = kojis
      o.kakes = kakes
      o.waters = waters
      o.lactic_acids = lactic_acids
      o.alcohols = alcohols
      o.yeasts = yeasts
    }
  end
end

class Koji
  include Toji::Ingredient::Koji

  attr_accessor :weight
  attr_accessor :soaking_ratio
  attr_accessor :steaming_ratio
  attr_accessor :cooling_ratio
  attr_accessor :tanekojis
  attr_accessor :dekoji_ratio
  attr_accessor :interval_days

  def initialize_copy(obj)
    self.weight = obj.weight.dup
    self.brand = obj.brand.dup
    self.polishing_ratio = obj.polishing_ratio.dup
    self.made_in = obj.made_in.dup
    self.year = obj.year.dup
    self.soaking_ratio = obj.soaking_ratio.dup
    self.steaming_ratio = obj.steaming_ratio.dup
    self.cooling_ratio = obj.cooling_ratio.dup

    self.tanekojis = obj.tanekojis.map {|tanekoji|
      tanekoji = tanekoji.dup
      tanekoji.koji = self
      tanekoji
    }

    self.dekoji_ratio = obj.dekoji_ratio.dup
    self.interval_days = obj.interval_days.dup
  end

  def self.create(weight:, brand:, polishing_ratio:, made_in:, year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, tanekojis:, dekoji_ratio:, interval_days:)
    new.tap {|o|
      o.weight = weight
      o.brand = brand
      o.polishing_ratio = polishing_ratio
      o.made_in = made_in
      o.year = year
      o.soaking_ratio = soaking_ratio
      o.steaming_ratio = steaming_ratio
      o.cooling_ratio = cooling_ratio
      o.tanekojis = tanekojis.map {|tanekoji|
        tanekoji.koji = o
        tanekoji
      }
      o.dekoji_ratio = dekoji_ratio
      o.interval_days = interval_days
    }
  end
end

class Tanekoji
  include Toji::Ingredient::Tanekoji

  def initialize_copy(obj)
    self.brand = obj.brand.dup
    self.ratio = obj.ratio.dup
  end

  def self.create(koji: nil, brand:, ratio:)
    new.tap {|o|
      o.brand = brand
      o.ratio = ratio
    }
  end
end

class Kake
  include Toji::Ingredient::Kake

  attr_accessor :weight
  attr_accessor :soaking_ratio
  attr_accessor :steaming_ratio
  attr_accessor :cooling_ratio
  attr_accessor :interval_days

  def self.create(weight:, brand:, polishing_ratio:, made_in:, year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, interval_days:)
    new.tap {|o|
      o.weight = weight
      o.brand = brand
      o.polishing_ratio = polishing_ratio
      o.made_in = made_in
      o.year = year
      o.soaking_ratio = soaking_ratio
      o.steaming_ratio = steaming_ratio
      o.cooling_ratio = cooling_ratio
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

class KojiSchedule
  include Toji::Schedule::KojiSchedule

  def initialize(product:, date:, step_indexes:, expect:)
    @product = product
    @date = date
    @step_indexes = step_indexes
    @expect = expect
  end
end

class KakeSchedule
  include Toji::Schedule::KakeSchedule

  def initialize(product:, date:, step_indexes:, expect:)
    @product = product
    @date = date
    @step_indexes = step_indexes
    @expect = expect
  end
end

class ActionSchedule
  include Toji::Schedule::ActionSchedule

  def initialize(product:, date:, type:, action_index:)
    @product = product
    @date = date
    @type = type
    @action_index = action_index
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
