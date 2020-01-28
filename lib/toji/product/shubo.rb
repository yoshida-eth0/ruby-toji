module Toji
  module Product
    class Shubo < Base

      TEMPLATES = {
        default: [
          Job.new(
            elapsed_time: 0 * Job::DAY,
            id: :mizukoji,
            temps: 12.0,
            acid: 13.0,
          ),
          Job.new(
            elapsed_time: 0 * Job::DAY + 1 * Job::HOUR,
            id: :shikomi,
            temps: 20.0,
            acid: 13.0,
          ),
          Job.new(
            elapsed_time: 1 * Job::DAY,
            id: :utase,
            temps: 14.0,
            baume: 15.0,
            acid: 13.0,
          ),
          Job.new(
            elapsed_time: 2 * Job::DAY,
            temps: [8.0, 11.0],
            baume: 16.0,
            acid: 13.0,
            warming: Job::WARM_DAKI,
          ),
          Job.new(
            elapsed_time: 3 * Job::DAY,
            temps: [10.0, 13.0],
            baume: 16.5,
            acid: 13.5,
            warming: Job::WARM_DAKI,
          ),
          Job.new(
            elapsed_time: 4 * Job::DAY,
            temps: [12.0, 15.0],
            baume: 17.0,
            acid: 13.5,
            warming: Job::WARM_DAKI,
          ),
          Job.new(
            elapsed_time: 5 * Job::DAY,
            temps: 14.0,
            baume: 17.0,
            acid: 14.0,
            warming: Job::WARM_ANKA,
          ),
          Job.new(
            elapsed_time: 6 * Job::DAY,
            temps: 20.0,
            baume: 17.0,
            acid: 14.5,
            warming: Job::WARM_ANKA,
          ),
          Job.new(
            elapsed_time: 7 * Job::DAY,
            temps: 20.0,
            baume: 14.0,
            acid: 15.5,
          ),
          Job.new(
            elapsed_time: 8 * Job::DAY,
            temps: 20.0,
            baume: 12.0,
            acid: 16.0,
          ),
          Job.new(
            elapsed_time: 9 * Job::DAY,
            id: :wake,
            temps: 20.0,
            baume: 9.0,
            acid: 16.0,
          ),
          Job.new(
            elapsed_time: 10 * Job::DAY,
            temps: 15.0,
            baume: 8.0,
            acid: 16.5,
          ),
          Job.new(
            elapsed_time: 11 * Job::DAY,
            temps: 12.0,
            baume: 7.0,
            acid: 17.0,
          ),
          Job.new(
            elapsed_time: 12 * Job::DAY,
            temps: 10.0,
            baume: 6.0,
            acid: 17.5,
          ),
          Job.new(
            elapsed_time: 13 * Job::DAY,
            temps: 9.0,
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
        super(jobs)
      end

      def day_labels
        days.times.map(&:succ)
      end

      def progress
        Graph::Progress.new(self)
      end

      def self.template(key=:default)
        new(TEMPLATES[key])
      end
    end
  end
end
