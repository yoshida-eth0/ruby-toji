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

  def initialize(steps:, actions:, ab_coef:, ab_expects:)
    @steps = steps
    @actions = actions
    @ab_coef = ab_coef
    @ab_expects = ab_expects
  end

  def initialize_copy(obj)
    @steps = obj.steps.deep_dup
    @actions = obj.actions.deep_dup
    @ab_coef = obj.ab_coef.dup
    @ab_expects = obj.ab_expects.deep_dup
  end
end

class Step
  include Toji::Recipe::Step

  def initialize(index:, subindex:, kojis: [], kakes: [], waters: [], lactic_acids: [], alcohols: [], yeasts: [])
    @index = index
    @subindex = subindex
    @kojis = kojis
    @kakes = kakes
    @waters = waters
    @lactic_acids = lactic_acids
    @alcohols = alcohols
    @yeasts = yeasts
  end

  def initialize_copy(obj)
    @index = obj.index
    @subindex = obj.subindex
    @kojis = obj.kojis&.deep_dup || []
    @kakes = obj.kakes&.deep_dup || []
    @waters = obj.waters&.deep_dup || []
    @lactic_acids = obj.lactic_acids&.deep_dup || []
    @alcohols = obj.alcohols&.deep_dup || []
    @yeasts = obj.yeasts&.deep_dup || []
  end
end

class Koji
  include Toji::Ingredient::Koji

  def initialize(weight:, brand:, polishing_ratio:, made_in:, year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, tanekojis:, dekoji_ratio:, interval_days:)
    @weight = weight
    @brand = brand
    @polishing_ratio = polishing_ratio
    @made_in = made_in
    @year = year
    @soaking_ratio = soaking_ratio
    @steaming_ratio = steaming_ratio
    @cooling_ratio = cooling_ratio
    @tanekojis = tanekojis.map {|tanekoji|
      tanekoji.koji = self
      tanekoji
    }
    @dekoji_ratio = dekoji_ratio
    @interval_days = interval_days
  end

  def initialize_copy(obj)
    @weight = obj.weight.dup
    @brand = obj.brand.dup
    @polishing_ratio = obj.polishing_ratio.dup
    @made_in = obj.made_in.dup
    @year = obj.year.dup
    @soaking_ratio = obj.soaking_ratio.dup
    @steaming_ratio = obj.steaming_ratio.dup
    @cooling_ratio = obj.cooling_ratio.dup

    @tanekojis = obj.tanekojis.map {|tanekoji|
      tanekoji = tanekoji.dup
      tanekoji.koji = self
      tanekoji
    }

    @dekoji_ratio = obj.dekoji_ratio.dup
    @interval_days = obj.interval_days.dup
  end
end

class Tanekoji
  include Toji::Ingredient::Tanekoji

  attr_accessor :koji

  def initialize(koji: nil, brand:, ratio:)
    @koji = koji
    @brand = brand
    @ratio = ratio
  end

  def initialize_copy(obj)
    @brand = obj.brand.dup
    @ratio = obj.ratio.dup
  end
end

class Kake
  include Toji::Ingredient::Kake

  def initialize(weight:, brand:, polishing_ratio:, made_in:, year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, interval_days:)
    @weight = weight
    @brand = brand
    @polishing_ratio = polishing_ratio
    @made_in = made_in
    @year = year
    @soaking_ratio = soaking_ratio
    @steaming_ratio = steaming_ratio
    @cooling_ratio = cooling_ratio
    @interval_days = interval_days
  end
end

class Water
  include Toji::Ingredient::Water

  def initialize(weight:, calcium_hardness: nil, magnesium_hardness: nil)
    @weight = weight
    @calcium_hardness = calcium_hardness
    @magnesium_hardness = magnesium_hardness
  end
end

class LacticAcid
  include Toji::Ingredient::LacticAcid

  def initialize(weight:)
    @weight = weight
  end
end

class Alcohol
  include Toji::Ingredient::Alcohol

  def initialize(weight:)
    @weight = weight
  end
end

class Yeast
  include Toji::Ingredient::Yeast

  def initialize(weight:)
    @weight = weight
  end
end

class Action
  include Toji::Recipe::Action

  def initialize(type:, interval_days:)
    @type = type
    @interval_days = interval_days
  end
end

class AbExpect
  include Toji::Recipe::AbExpect

  def initialize(alcohol:, nihonshudo:)
    @alcohol = alcohol
    @nihonshudo = nihonshudo
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


class KojiProcessing
  include Toji::Processing::KojiProcessing

  attr_reader :koji_progress

  def initialize(date:, expect:, soaked_rice:, steamed_rice:, cooled_rice:, koji_progress:, dekoji:)
    @date = date
    @expect = expect
    @soaked_rice = soaked_rice
    @soaked_rice.processing = self
    @steamed_rice = steamed_rice
    @steamed_rice.processing = self
    @cooled_rice = cooled_rice
    @cooled_rice.processing = self
    @koji_progress = koji_progress
    @dekoji = dekoji
    @dekoji.processing = self
  end
end

class KakeProcessing
  include Toji::Processing::KakeProcessing

  def initialize(date:, expect:, soaked_rice:, steamed_rice:, cooled_rice:)
    @date = date
    @expect = expect
    @soaked_rice = soaked_rice
    @soaked_rice.processing = self
    @steamed_rice = steamed_rice
    @steamed_rice.processing = self
    @cooled_rice = cooled_rice
    @cooled_rice.processing = self
  end
end

class SoakedRice
  include Toji::Processing::SoakedRice

  attr_accessor :processing

  def initialize(room_temp:, outside_temp:, rice_water_content:, washing_water_temp:, soaking_water_temp:, elements: [])
    @room_temp = room_temp
    @outside_temp = outside_temp
    @rice_water_content = rice_water_content
    @washing_water_temp = washing_water_temp
    @soaking_water_temp = soaking_water_temp
    @elements = elements
  end
end

class SoakedRiceElement
  include Toji::Processing::SoakedRiceElement

  def initialize(weight:, soaking_time:, soaked:)
    @weight = weight
    @soaking_time = soaking_time
    @soaked = soaked
  end
end

class SteamedRice
  include Toji::Processing::SteamedRice

  attr_accessor :processing

  def initialize(elements: [])
    @elements = elements
  end
end

class SteamedRiceElement
  include Toji::Processing::SteamedRiceElement

  def initialize(weight:)
    @weight = weight
  end
end

class CooledRice
  include Toji::Processing::CooledRice

  attr_accessor :processing

  def initialize(elements: [])
    @elements = elements
  end
end

class CooledRiceElement
  include Toji::Processing::CooledRiceElement

  def initialize(weight:)
    @weight = weight
  end
end

class Dekoji
  include Toji::Processing::Dekoji

  attr_accessor :processing

  def initialize(elements: [])
    @elements = elements
  end
end

class DekojiElement
  include Toji::Processing::DekojiElement

  def initialize(weight:)
    @weight = weight
  end
end


class KojiProgress
  include Toji::Progress::KojiProgress

  def initialize(states:)
    @states = states.map {|state|
      state.progress = self
      state
    }.sort_by(&:time)
  end

  def base_time
    states.first.time
  end

  def day_offset
    (base_time - Time.mktime(base_time.year, base_time.month, base_time.day)).to_i
  end
end

class KojiState
  include Toji::Progress::KojiState

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
  include Toji::Progress::MotoProgress

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
  include Toji::Progress::MotoState

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
  include Toji::Progress::MoromiProgress

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
  include Toji::Progress::MoromiState
  include Toji::Progress::State::BaumeToNihonshudo

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
