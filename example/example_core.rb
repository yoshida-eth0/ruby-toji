require 'securerandom'

module Example

  module Brew
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

    module BrewGenerator
      def builder
        Toji::Brew::Builder.new(self)
      end

      def load_hash(hash)
        hash = hash.deep_symbolize_keys

        builder
          .add((hash[:states] || []).map{|s| State.create(s)})
          .date_line(hash[:date_line] || 0, Toji::Brew::HOUR)
          .prefix_day_labels(hash[:prefix_day_labels])
          .time_interpolation(nil)
          .elapsed_time_interpolation
          .build
      end

      def load_yaml_file(fname)
        hash = YAML.load_file(fname)
        load_hash(hash)
      end
    end

    class Base
      include Toji::Brew::Base
      extend BrewGenerator

      def initialize
        @states = []
        @day_offset = 0
        @base_time = 0
      end
    end

    class Koji < Base
      include Toji::Brew::Koji
    end

    class Shubo < Base
      include Toji::Brew::Shubo
    end

    class Moromi < Base
      include Toji::Brew::Moromi
    end
  end


  class Step
    include Toji::Recipe::Step

    def to_h
      {
        name: name,
        kake: kake,
        koji: koji,
        water: water,
        lactic_acid: lactic_acid,
        alcohol: alcohol,
        yeast: yeast,
        koji_interval_days: koji_interval_days,
        kake_interval_days: kake_interval_days,
      }
    end

    def self.create(name:, kake: 0, koji: 0, water: 0, lactic_acid: 0, alcohol: 0, yeast: 0, koji_interval_days: 0, kake_interval_days: 0)
      new.tap {|o|
        o.name = name
        o.kake = kake.to_f
        o.koji = koji.to_f
        o.water = water.to_f
        o.lactic_acid = lactic_acid.to_f
        o.alcohol = alcohol.to_f
        o.yeast = yeast.to_f
        o.koji_interval_days = koji_interval_days.to_i
        o.kake_interval_days = kake_interval_days.to_i
      }
    end
  end


  class Recipe
    include Toji::Recipe

    def initialize
      @steps = []
    end

    #def to_h
    #  {
    #    steps: steps.map(&:to_h),
    #    cumulative_rice_totals: cumulative_rice_totals,
    #    cumulative_shubo_rates: cumulative_shubo_rates,
    #    shubo_rate: shubo_rate,
    #    rice_rates: rice_rates,
    #  }
    #end

    def self.create(steps)
      new.tap {|o|
        o.steps = steps
      }
    end

    # 乳酸は汲水100L当たり比重1.21の乳酸(90%乳酸と称される)を650〜720ml添加する。
    # 添加する酵母の量は、酒母の総米100kg当たり協会酵母アンプル1〜2本である。
    #
    # 出典: 酒造教本 P80
    #
    # ここでは間をとって乳酸は685ml、酵母は1.5本とする。
    TEMPLATES = {
      # 酒造教本による標準型仕込配合
      # 出典: 酒造教本 P97
      sokujo_textbook: create(
        [
          Step.create(
            name: :moto,
            kake: 45,
            koji: 20,
            water: 70,
            lactic_acid: 70/100.0*0.685,
            yeast: (45+20)/100.0*1.5,
            koji_interval_days: 0,
            kake_interval_days: 5,
          ),
          Step.create(
            name: :soe,
            kake: 100,
            koji: 40,
            water: 130,
            koji_interval_days: 14,
            kake_interval_days: 15,
          ),
          Step.create(
            name: :naka,
            kake: 215,
            koji: 60,
            water: 330,
            koji_interval_days: 0,
            kake_interval_days: 2,
          ),
          Step.create(
            name: :tome,
            kake: 360,
            koji: 80,
            water: 630,
            koji_interval_days: 0,
            kake_interval_days: 1,
          ),
          Step.create(
            name: :yodan,
            kake: 80,
            water: 120,
            kake_interval_days: 25,
          ),
        ].map(&:freeze).freeze
      ).freeze,
      # 灘における仕込配合の平均値
      # 出典: http://www.nada-ken.com/main/jp/index_shi/234.html
      sokujo_nada: create(
        [
          Step.create(
            name: :moto,
            kake: 93,
            koji: 47,
            water: 170,
            lactic_acid: 170/100.0*0.685,
            yeast: (93+47)/100.0*1.5,
            koji_interval_days: 0,
            kake_interval_days: 5,
          ),
          Step.create(
            name: :soe,
            kake: 217,
            koji: 99,
            water: 270,
            koji_interval_days: 14,
            kake_interval_days: 15,
          ),
          Step.create(
            name: :naka,
            kake: 423,
            koji: 143,
            water: 670,
            koji_interval_days: 0,
            kake_interval_days: 2,
          ),
          Step.create(
            name: :tome,
            kake: 813,
            koji: 165,
            water: 1330,
            koji_interval_days: 0,
            kake_interval_days: 1,
          ),
          Step.create(
            name: :alcohol,
            alcohol: 900
          ),
        ].map(&:freeze).freeze
      ).freeze,
      # 簡易酒母省略仕込
      # 出典: https://www.jstage.jst.go.jp/article/jbrewsocjapan1915/60/11/60_11_999/_article/-char/ja/
      simple_sokujo_himeno: create(
        [
          Step.create(
            name: :moto,
            kake: 0,
            koji: 70,
            water: 245,
            lactic_acid: 1.6,
            yeast: 5,
            koji_interval_days: 0,
            kake_interval_days: 6,
          ),
          Step.create(
            name: :soe,
            kake: 130,
            koji: 0,
            water: 0,
            koji_interval_days: 0,
            kake_interval_days: 1,
          ),
          Step.create(
            name: :naka,
            kake: 300,
            koji: 100,
            water: 400,
            koji_interval_days: 0,
            kake_interval_days: 2,
          ),
          Step.create(
            name: :tome,
            kake: 490,
            koji: 110,
            water: 800,
            koji_interval_days: 0,
            kake_interval_days: 1,
          ),
          Step.create(
            name: :yodan,
            water: 255
          ),
        ].map(&:freeze).freeze
      ).freeze,
    }.freeze
  end


  class Product
    include Toji::Product

    attr_accessor :description
    attr_accessor :color

    def initialize(reduce_key, name, description, recipe, start_date, color=nil)
      @reduce_key = reduce_key || SecureRandom.uuid
      @name = name
      @description = description
      @recipe = recipe
      @start_date = start_date
      @color = color
    end

    def to_h
      {
        id: id,
        name: name,
        description: @description,
        recipe: @recipe.table_data,
        start_date: @start_date,
        koji_dates: koji_dates,
        kake_dates: kake_dates,
        events: events.map(&:to_h),
        events_group: events_group,
        color: @color,
      }
    end

    def self.create(args)
      if self===args
        args
      elsif Hash===args
        recipe = args.fetch(:recipe)
        if Symbol===recipe
          recipe = Recipe::TEMPLATES.fetch(recipe)
        end
        if args[:scale]
          recipe = recipe.scale(args[:scale])
        end
        if args[:round]
          recipe = recipe.round(args[:round])
        end

        new(
          args[:id],
          args[:name],
          args[:description],
          recipe,
          args[:start_date],
          args[:color]
        )
      else
        raise "not supported class: #{args.class}"
      end
    end
  end


  class Calendar < Toji::Calendar

    def self.load_hash(hash)
      hash = hash.deep_symbolize_keys
      products = hash[:products] || []

      cal = new
      products.each {|product|
        cal.add(Product.create(product))
      }

      cal
    end

    def self.load_yaml_file(fname)
      hash = YAML.load_file(fname)
      load_hash(hash)
    end
  end
end
