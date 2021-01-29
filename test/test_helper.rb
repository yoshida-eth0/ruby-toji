$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "toji"

class Product
  include Toji::Product
  include Toji::Product::ScheduleFactory

  attr_reader :serial_num
  attr_reader :recipe
  attr_reader :base_date

  def initialize(serial_num, recipe, base_date)
    @serial_num = serial_num
    @recipe = recipe
    @base_date = base_date
  end

  def create_koji_schedule(date:, group_key:, step_weights:, kojis:)
    expect = kojis.first.dup
    expect.weight = kojis.map(&:weight).sum

    KojiSchedule.new(
      product: self,
      date: date,
      group_key: group_key,
      step_weights: step_weights,
      expect: expect,
    )
  end

  def create_kake_schedule(date:, group_key:, step_weights:, kakes:)
    expect = kakes.first.dup
    expect.weight = kakes.map(&:weight).sum

    KakeSchedule.new(
      product: self,
      date: date,
      group_key: group_key,
      step_weights: step_weights,
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

  attr_reader :steps
  attr_reader :actions
  attr_reader :ab_coef
  attr_reader :ab_expects

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

  attr_reader :index
  attr_reader :subindex
  attr_accessor :kojis
  attr_accessor :kakes
  attr_accessor :waters
  attr_accessor :lactic_acids
  attr_accessor :alcohols
  attr_accessor :yeasts

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

  attr_accessor :weight
  attr_reader :brand
  attr_reader :polishing_ratio
  attr_reader :made_in
  attr_reader :farmer
  attr_reader :rice_year
  attr_reader :soaking_ratio
  attr_reader :steaming_ratio
  attr_reader :cooling_ratio
  attr_reader :tanekojis
  attr_reader :dekoji_ratio
  attr_reader :interval_days
  attr_reader :process_group

  def initialize(weight:, brand:, polishing_ratio:, made_in:, farmer:, rice_year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, tanekojis:, dekoji_ratio:, interval_days:)
    @weight = weight
    @brand = brand
    @polishing_ratio = polishing_ratio
    @made_in = made_in
    @farmer = farmer
    @rice_year = rice_year
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
    @farmer = obj.farmer.dup
    @rice_year = obj.rice_year.dup
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
  attr_reader :brand
  attr_reader :ratio

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

  attr_accessor :weight
  attr_reader :brand
  attr_reader :polishing_ratio
  attr_reader :made_in
  attr_reader :farmer
  attr_reader :rice_year
  attr_reader :soaking_ratio
  attr_reader :steaming_ratio
  attr_reader :cooling_ratio
  attr_reader :interval_days
  attr_reader :process_group

  def initialize(weight:, brand:, polishing_ratio:, made_in:, farmer:, rice_year:, soaking_ratio:, steaming_ratio:, cooling_ratio:, interval_days:)
    @weight = weight
    @brand = brand
    @polishing_ratio = polishing_ratio
    @made_in = made_in
    @farmer = farmer
    @rice_year = rice_year
    @soaking_ratio = soaking_ratio
    @steaming_ratio = steaming_ratio
    @cooling_ratio = cooling_ratio
    @interval_days = interval_days
  end
end

class Water
  include Toji::Ingredient::Water

  attr_accessor :weight
  attr_reader :calcium_hardness
  attr_reader :magnesium_hardness

  def initialize(weight:, calcium_hardness: nil, magnesium_hardness: nil)
    @weight = weight
    @calcium_hardness = calcium_hardness
    @magnesium_hardness = magnesium_hardness
  end
end

class LacticAcid
  include Toji::Ingredient::LacticAcid

  attr_accessor :weight

  def initialize(weight:)
    @weight = weight
  end
end

class Alcohol
  include Toji::Ingredient::Alcohol

  attr_accessor :weight

  def initialize(weight:)
    @weight = weight
  end
end

class Yeast
  include Toji::Ingredient::Yeast

  attr_accessor :weight
  attr_reader :unit
  attr_reader :brand

  def initialize(weight:)
    @weight = weight
  end
end

class Action
  include Toji::Recipe::Action

  attr_reader :type
  attr_reader :interval_days

  def initialize(type:, interval_days:)
    @type = type
    @interval_days = interval_days
  end
end

class AbExpect
  include Toji::Recipe::AbExpect

  attr_reader :alcohol
  attr_reader :nihonshudo

  def initialize(alcohol:, nihonshudo:)
    @alcohol = alcohol
    @nihonshudo = nihonshudo
  end
end


class KojiSchedule
  include Toji::Schedule::KojiSchedule

  attr_reader :product
  attr_reader :date
  attr_reader :group_key

  attr_reader :step_weights
  attr_reader :expect

  def initialize(product:, date:, group_key:, step_weights:, expect:)
    @product = product
    @date = date
    @group_key = group_key
    @step_weights = step_weights
    @expect = expect
  end
end

class KakeSchedule
  include Toji::Schedule::KakeSchedule

  attr_reader :product
  attr_reader :date
  attr_reader :group_key

  attr_reader :step_weights
  attr_reader :expect

  def initialize(product:, date:, group_key:, step_weights:, expect:)
    @product = product
    @date = date
    @group_key = group_key
    @step_weights = step_weights
    @expect = expect
  end
end

class ActionSchedule
  include Toji::Schedule::ActionSchedule

  attr_reader :product
  attr_reader :date
  attr_reader :type

  attr_reader :action_index

  def initialize(product:, date:, type:, action_index:)
    @product = product
    @date = date
    @type = type
    @action_index = action_index
  end
end


class KojiProcessing
  include Toji::Processing::KojiProcessing

  attr_reader :date
  attr_reader :expect
  attr_reader :soaked_rice
  attr_reader :steamed_rice
  attr_reader :cooled_rice
  attr_reader :dekoji

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

  attr_reader :date
  attr_reader :expect
  attr_reader :soaked_rice
  attr_reader :steamed_rice
  attr_reader :cooled_rice

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

  attr_reader :room_temp
  attr_reader :outside_temp
  attr_reader :rice_water_content
  attr_reader :washing_water_temp
  attr_reader :soaking_water_temp
  attr_accessor :processing
  attr_reader :elements

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

  attr_reader :weight
  attr_reader :soaking_time
  attr_reader :soaked

  def initialize(weight:, soaking_time:, soaked:)
    @weight = weight
    @soaking_time = soaking_time
    @soaked = soaked
  end
end

class SteamedRice
  include Toji::Processing::SteamedRice

  attr_accessor :processing
  attr_reader :elements

  def initialize(elements: [])
    @elements = elements
  end
end

class SteamedRiceElement
  include Toji::Processing::SteamedRiceElement

  attr_reader :weight

  def initialize(weight:)
    @weight = weight
  end
end

class CooledRice
  include Toji::Processing::CooledRice

  attr_accessor :processing
  attr_reader :elements

  def initialize(elements: [])
    @elements = elements
  end
end

class CooledRiceElement
  include Toji::Processing::CooledRiceElement

  attr_reader :weight

  def initialize(weight:)
    @weight = weight
  end
end

class Dekoji
  include Toji::Processing::Dekoji

  attr_accessor :processing
  attr_reader :elements

  def initialize(elements: [])
    @elements = elements
  end
end

class DekojiElement
  include Toji::Processing::DekojiElement

  attr_reader :weight

  def initialize(weight:)
    @weight = weight
  end
end


class KojiProgress
  include Toji::Progress::KojiProgress

  attr_reader :states
  attr_reader :date_line

  def initialize(states:)
    @states = states.map {|state|
      state.progress = self
      state
    }.sort_by(&:time)
    @date_line = 0
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

  attr_accessor :progress
  attr_accessor :time
  attr_accessor :mark

  attr_accessor :temps
  attr_accessor :preset_temp
  attr_accessor :room_temp
  attr_accessor :room_psychrometry
  attr_accessor :note

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

  attr_reader :states
  attr_reader :date_line

  def initialize
    @states = [
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
    ].sort_by(&:time)
    @date_line = 0
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

  attr_accessor :progress
  attr_accessor :time
  attr_accessor :mark

  attr_accessor :temps
  attr_accessor :preset_temp
  attr_accessor :room_temp
  attr_accessor :room_psychrometry
  attr_accessor :baume
  attr_accessor :acid
  attr_accessor :warmings
  attr_accessor :note

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

  attr_reader :states
  attr_reader :date_line
  attr_reader :prefix_day_labels

  def initialize
    @states = [
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
    ].sort_by(&:time)
    @date_line = 0
    @prefix_day_labels = ["添", "踊", "踊", "仲", "留"]
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

  attr_accessor :progress
  attr_accessor :time
  attr_accessor :mark

  attr_accessor :temps
  attr_accessor :preset_temp
  attr_accessor :room_temp
  attr_accessor :room_psychrometry
  attr_accessor :baume
  attr_accessor :acid
  attr_accessor :amino_acid
  attr_accessor :alcohol
  attr_accessor :warmings
  attr_accessor :note

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
