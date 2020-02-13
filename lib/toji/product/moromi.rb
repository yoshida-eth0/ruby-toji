module Toji
  module Product
    class Moromi < Base

      TEMPLATES = {
        default: [
          Job.new(
            time: Time.mktime(2019, 1, 16),
            id: :soe,
            room_temp: 9,
            temps: [14.8, 11.0],
          ),
          Job.new(
            time: Time.mktime(2019, 1, 17),
            room_temp: 9,
            temps: 14.3,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 18),
            room_temp: 8.5,
            temps: 11.3,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 19),
            id: :naka,
            room_temp: 9,
            temps: [6.9, 10.6],
          ),
          Job.new(
            time: Time.mktime(2019, 1, 20),
            id: :tome,
            room_temp: 6,
            temps: [7.5, 8.0],
          ),
          Job.new(
            time: Time.mktime(2019, 1, 21),
            room_temp: 7,
            temps: 9.1,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 22),
            room_temp: 7,
            temps: 10.4,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 23),
            room_temp: 8,
            temps: 11.9,
            baume: 8.6,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 24),
            room_temp: 8,
            temps: 12.3,
            baume: 8.0,
            alcohol: 4.8,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 25),
            room_temp: 7.5,
            temps: 13.1,
            baume: 7.2,
            alcohol: 6.75,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 26),
            room_temp: 7.5,
            temps: 13.1,
            baume: 5.8,
            alcohol: 7.992,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 27),
            room_temp: 7.5,
            temps: 12.9,
            baume: 4.8,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 28),
            room_temp: 7.0,
            temps: 12.8,
            baume: 4.0,
            alcohol: 10.7,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 29),
            room_temp: 8.0,
            temps: 12.9,
            baume: 3.4,
            alcohol: 11.6,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 30),
            room_temp: 8.0,
            temps: 12.6,
            nihonshudo: -27,
            alcohol: 12.7,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 31),
            room_temp: 7.0,
            temps: 12.0,
            nihonshudo: -21,
            alcohol: 13.7,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 1),
            room_temp: 7.0,
            temps: 11.2,
            nihonshudo: -17,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 2),
            room_temp: 6.5,
            temps: 10.2,
            nihonshudo: -13,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 3),
            room_temp: 7.0,
            temps: 9.7,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 4),
            room_temp: 8.0,
            temps: 9.8,
            nihonshudo: -8,
            alcohol: 16.0,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 5),
            room_temp: 6.0,
            temps: 9.1,
            nihonshudo: -5,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 6),
            room_temp: 5.0,
            temps: 8.4,
            nihonshudo: -3,
            alcohol: 16.3,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 7),
            room_temp: 5.0,
            temps: 8.1,
            nihonshudo: -2,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 8),
            room_temp: 7.0,
            temps: 8.3,
            nihonshudo: 0,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 9),
            room_temp: 6.0,
            temps: 8.1,
          ),
        ],
      }


      job_reader :moto
      job_reader :soe
      job_reader :naka
      job_reader :tome
      job_reader :yodan

      def initialize(jobs=[], date_line: 0, day_labels: nil)
        super(jobs, date_line: date_line)

        if day_labels
          @day_labels = [day_labels].flatten
        end
      end

      def moromi_days
        if @day_labels
          days - @day_labels.length
        else
          tome = self[:tome]
          if tome
            tome_day = (tome.elapsed_time.to_f / Job::DAY).floor + 1
            days - tome_day
          end
        end
      end

      def day_labels
        if @day_labels
          @day_labels + moromi_days.times.map{|i| i+2}
        else
          texts = Array.new(days)
          [:soe, :naka, :tome].each {|id|
            j = select{|j| j.id==id}.first
            if j
              i = ((j.elapsed_time + day_offset) / Job::DAY.to_f).floor
              texts[i] = id
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
        new(TEMPLATES[key])
      end
    end
  end
end
