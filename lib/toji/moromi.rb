module Toji
  class Moromi
    include Product

    TEMPLATES = {
      default: [
        {
          time: Time.mktime(2019, 1, 16),
          mark: :soe,
          room_temp: 9,
          temps: [14.8, 11.0],
        },
        {
          time: Time.mktime(2019, 1, 17),
          room_temp: 9,
          temps: 14.3,
        },
        {
          time: Time.mktime(2019, 1, 18),
          room_temp: 8.5,
          temps: 11.3,
        },
        {
          time: Time.mktime(2019, 1, 19),
          mark: :naka,
          room_temp: 9,
          temps: [6.9, 10.6],
        },
        {
          time: Time.mktime(2019, 1, 20),
          mark: :tome,
          room_temp: 6,
          temps: [7.5, 8.0],
        },
        {
          time: Time.mktime(2019, 1, 21),
          room_temp: 7,
          temps: 9.1,
        },
        {
          time: Time.mktime(2019, 1, 22),
          room_temp: 7,
          temps: 10.4,
        },
        {
          time: Time.mktime(2019, 1, 23),
          room_temp: 8,
          temps: 11.9,
          baume: 8.6,
        },
        {
          time: Time.mktime(2019, 1, 24),
          room_temp: 8,
          temps: 12.3,
          baume: 8.0,
          alcohol: 4.8,
        },
        {
          time: Time.mktime(2019, 1, 25),
          room_temp: 7.5,
          temps: 13.1,
          baume: 7.2,
          alcohol: 6.75,
        },
        {
          time: Time.mktime(2019, 1, 26),
          room_temp: 7.5,
          temps: 13.1,
          baume: 5.8,
          alcohol: 7.992,
        },
        {
          time: Time.mktime(2019, 1, 27),
          room_temp: 7.5,
          temps: 12.9,
          baume: 4.8,
        },
        {
          time: Time.mktime(2019, 1, 28),
          room_temp: 7.0,
          temps: 12.8,
          baume: 4.0,
          alcohol: 10.7,
        },
        {
          time: Time.mktime(2019, 1, 29),
          room_temp: 8.0,
          temps: 12.9,
          baume: 3.4,
          alcohol: 11.6,
        },
        {
          time: Time.mktime(2019, 1, 30),
          room_temp: 8.0,
          temps: 12.6,
          nihonshudo: -27,
          alcohol: 12.7,
        },
        {
          time: Time.mktime(2019, 1, 31),
          room_temp: 7.0,
          temps: 12.0,
          nihonshudo: -21,
          alcohol: 13.7,
        },
        {
          time: Time.mktime(2019, 2, 1),
          room_temp: 7.0,
          temps: 11.2,
          nihonshudo: -17,
        },
        {
          time: Time.mktime(2019, 2, 2),
          room_temp: 6.5,
          temps: 10.2,
          nihonshudo: -13,
        },
        {
          time: Time.mktime(2019, 2, 3),
          room_temp: 7.0,
          temps: 9.7,
        },
        {
          time: Time.mktime(2019, 2, 4),
          room_temp: 8.0,
          temps: 9.8,
          nihonshudo: -8,
          alcohol: 16.0,
        },
        {
          time: Time.mktime(2019, 2, 5),
          room_temp: 6.0,
          temps: 9.1,
          nihonshudo: -5,
        },
        {
          time: Time.mktime(2019, 2, 6),
          room_temp: 5.0,
          temps: 8.4,
          nihonshudo: -3,
          alcohol: 16.3,
        },
        {
          time: Time.mktime(2019, 2, 7),
          room_temp: 5.0,
          temps: 8.1,
          nihonshudo: -2,
        },
        {
          time: Time.mktime(2019, 2, 8),
          room_temp: 7.0,
          temps: 8.3,
          nihonshudo: 0,
        },
        {
          time: Time.mktime(2019, 2, 9),
          room_temp: 6.0,
          temps: 8.1,
        },
      ],
    }

    DAY_LABELS = {
      default: [:soe, :odori, :naka, :tome].freeze,
      moto1: [:moto, :soe, :odori, :naka, :tome].freeze,
      odori2: [:soe, :odori, :odori, :naka, :tome].freeze,
    }.freeze

    state_reader :moto
    state_reader :soe
    state_reader :naka
    state_reader :tome
    state_reader :yodan

    def initialize(data, day_labels: nil)
      if day_labels
        @day_labels = [day_labels].flatten
      end

      self.data = data
    end

    def moromi_days
      if @day_labels
        @data.days - @day_labels.length
      else
        @data.states.last.moromi_day || @data.days
      end
    end

    def day_labels
      if @day_labels
        @day_labels + moromi_days.times.map{|i| i+2}
      elsif !@data[:soe] && !@data[:tome]
        @data.days.times.map{|i| i+1}
      else
        texts = Array.new(@data.days)
        [:soe, :naka, :tome].each {|mark|
          j = @data[mark]
          if j
            i = (j.elapsed_time_with_offset / DAY.to_f).floor
            texts[i] = mark
          end
        }

        soe_i = texts.index(:soe)
        tome_i = texts.index(:tome)
        moromi_day = 1
        texts.map.with_index {|text,i|
          if text
            text
          elsif !soe_i || i<soe_i
            :moto
          elsif !tome_i || i<tome_i
            :odori
          else
            moromi_day += 1
          end
        }
      end
    end

    def progress(enable_annotations: true)
      Graph::Progress.new(self, enable_annotations: enable_annotations)
    end

    def bmd
      Graph::Bmd.new.actual(self)
    end

    def ab(coef=1.5)
      Graph::Ab.new(coef).actual(self)
    end

    def self.template(key=:default)
      create(TEMPLATES[key])
    end
  end
end
