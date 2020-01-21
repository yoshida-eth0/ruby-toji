module Toji
  module Progress
    class Shubo
      extend JobAccessor

      TEMPLATES = {
        default: [
          Job.new(
            elapsed_time: 0 * Job::DAY,
            id: :mizukoji,
            after_temp: 12.0,
            acid: 13.0,
          ),
          Job.new(
            elapsed_time: 0 * Job::DAY + 1 * Job::HOUR,
            id: :shikomi,
            after_temp: 20.0,
            acid: 13.0,
          ),
          Job.new(
            elapsed_time: 1 * Job::DAY,
            id: :utase,
            after_temp: 14.0,
            baume: 15.0,
            acid: 13.0,
          ),
          Job.new(
            elapsed_time: 2 * Job::DAY,
            before_temp: 8.0,
            after_temp: 11.0,
            baume: 16.0,
            acid: 13.0,
            warming: Job::WARM_DAKI,
          ),
          Job.new(
            elapsed_time: 3 * Job::DAY,
            before_temp: 10.0,
            after_temp: 13.0,
            baume: 16.5,
            acid: 13.5,
            warming: Job::WARM_DAKI,
          ),
          Job.new(
            elapsed_time: 4 * Job::DAY,
            before_temp: 12.0,
            after_temp: 15.0,
            baume: 17.0,
            acid: 13.5,
            warming: Job::WARM_DAKI,
          ),
          Job.new(
            elapsed_time: 5 * Job::DAY,
            after_temp: 14.0,
            baume: 17.0,
            acid: 14.0,
            warming: Job::WARM_ANKA,
          ),
          Job.new(
            elapsed_time: 6 * Job::DAY,
            after_temp: 20.0,
            baume: 17.0,
            acid: 14.5,
            warming: Job::WARM_ANKA,
          ),
          Job.new(
            elapsed_time: 7 * Job::DAY,
            after_temp: 20.0,
            baume: 14.0,
            acid: 15.5,
          ),
          Job.new(
            elapsed_time: 8 * Job::DAY,
            after_temp: 20.0,
            baume: 12.0,
            acid: 16.0,
          ),
          Job.new(
            elapsed_time: 9 * Job::DAY,
            id: :wake,
            after_temp: 20.0,
            baume: 9.0,
            acid: 16.0,
          ),
          Job.new(
            elapsed_time: 10 * Job::DAY,
            after_temp: 15.0,
            baume: 8.0,
            acid: 16.5,
          ),
          Job.new(
            elapsed_time: 11 * Job::DAY,
            after_temp: 12.0,
            baume: 7.0,
            acid: 17.0,
          ),
          Job.new(
            elapsed_time: 12 * Job::DAY,
            after_temp: 10.0,
            baume: 6.0,
            acid: 17.5,
          ),
          Job.new(
            elapsed_time: 13 * Job::DAY,
            after_temp: 9.0,
            baume: 5.0,
            acid: 17.5,
          ),
        ],
      }


      job_reader :mizukoji
      job_reader :shikomi
      job_reader :utase
      job_reader :wake

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

      def plot_data
        @jobs.plot_data
      end

      def plot
        _days = days

        Plotly::Plot.new(
          data: plot_data,
          layout: {
            xaxis: {
              dtick: 24*60*60,
              tickvals: _days.times.map{|d| d*Job::DAY},
              ticktext: (1.._days).to_a
            }
          }
        )
      end

      def self.template(key=:default)
        new(TEMPLATES[key])
      end
    end
  end
end
