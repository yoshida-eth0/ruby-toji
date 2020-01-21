module Toji
  module Progress
    class Moromi
      extend JobAccessor

      TEMPLATES = {
        default: [
          Job.new(
            time: Time.mktime(2019, 1, 16),
            id: :soe,
            room_temp: 9,
            before_temp: 14.8,
            after_temp: 11.0,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 17),
            room_temp: 9,
            before_temp: 14.3,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 18),
            room_temp: 8.5,
            before_temp: 11.3,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 19),
            id: :naka,
            room_temp: 9,
            before_temp: 6.9,
            after_temp: 10.6,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 20),
            id: :tome,
            room_temp: 6,
            before_temp: 7.5,
            after_temp: 8.0,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 21),
            room_temp: 7,
            before_temp: 9.1,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 22),
            room_temp: 7,
            before_temp: 10.4,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 23),
            room_temp: 8,
            before_temp: 11.9,
            baume: 8.6,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 24),
            room_temp: 8,
            before_temp: 12.3,
            baume: 8.0,
            alcohol: 4.8,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 25),
            room_temp: 7.5,
            before_temp: 13.1,
            baume: 7.2,
            alcohol: 6.75,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 26),
            room_temp: 7.5,
            before_temp: 13.1,
            baume: 5.8,
            alcohol: 7.992,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 27),
            room_temp: 7.5,
            before_temp: 12.9,
            baume: 4.8,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 28),
            room_temp: 7.0,
            before_temp: 12.8,
            baume: 4.0,
            alcohol: 10.7,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 29),
            room_temp: 8.0,
            before_temp: 12.9,
            baume: 3.4,
            alcohol: 11.6,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 30),
            room_temp: 8.0,
            before_temp: 12.6,
            nihonshudo: -27,
            alcohol: 12.7,
          ),
          Job.new(
            time: Time.mktime(2019, 1, 31),
            room_temp: 7.0,
            before_temp: 12.0,
            nihonshudo: -21,
            alcohol: 13.7,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 1),
            room_temp: 7.0,
            before_temp: 11.2,
            nihonshudo: -17,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 2),
            room_temp: 6.5,
            before_temp: 10.2,
            nihonshudo: -13,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 3),
            room_temp: 7.0,
            before_temp: 9.7,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 4),
            room_temp: 8.0,
            before_temp: 9.8,
            nihonshudo: -8,
            alcohol: 16.0,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 5),
            room_temp: 6.0,
            before_temp: 9.1,
            nihonshudo: -5,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 6),
            room_temp: 5.0,
            before_temp: 8.4,
            nihonshudo: -3,
            alcohol: 16.3,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 7),
            room_temp: 5.0,
            before_temp: 8.1,
            nihonshudo: -2,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 8),
            room_temp: 7.0,
            before_temp: 8.3,
            nihonshudo: 0,
          ),
          Job.new(
            time: Time.mktime(2019, 2, 9),
            room_temp: 6.0,
            before_temp: 8.1,
          ),
        ],
      }


      job_reader :moto
      job_reader :soe
      job_reader :naka
      job_reader :tome

      def initialize(jobs=[])
        @jobs = Jobs.new(jobs)
      end

      def add(job)
        @jobs << job
        self
      end

      def jobs
        @jobs.to_a
      end

      def days
        (jobs.last.elapsed_time.to_f / Job::DAY).ceil + 1
      end

      def moromi_days
        tome = @jobs[:tome]
        if tome
          tome_day = (tome.elapsed_time.to_f / Job::DAY).floor + 1
          days - tome_day
        end
      end

      def day_labels
        texts = Array.new(days)
        [:soe, :naka, :tome].each {|id|
          j = jobs.select{|j| j.id==id}.first
          if j
            i = ((j.elapsed_time + @jobs.day_offset) / Job::DAY.to_f).floor
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

      def plot_data
        @jobs.plot_data
      end

      def plot
        Plotly::Plot.new(
          data: plot_data,
          layout: {
            xaxis: {
              dtick: Job::DAY,
              tickvals: days.times.map{|d| d*Job::DAY},
              ticktext: day_labels
            }
          }
        )
      end

      def bmd_plot_data
        @jobs.bmd_plot_data
      end

      def bmd_plot
        data = [bmd_plot_data]
        max_moromi_day = moromi_days || 0
        max_moromi_day = [max_moromi_day, 14].max

        Plotly::Plot.new(
          data: data,
          layout: {
            xaxis: {
              title: "Moromi day",
              dtick: Job::DAY,
              range: [1, max_moromi_day].map{|d| d*Job::DAY},
              tickvals: days.times.map{|d| d*Job::DAY},
              ticktext: days.times.map(&:succ)
            },
            yaxis: {
              title: "BMD",
            }
          }
        )
      end

      def ab(coef=1.5)
        Graph::Ab.new(coef).actual(@jobs)
      end

      def self.template(key=:default)
        new(TEMPLATES[key])
      end
    end
  end
end
