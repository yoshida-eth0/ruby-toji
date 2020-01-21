module Toji
  module Progress
    class MakeKoji
      extend JobAccessor

      TEMPLATES = {
        default: [
          Job.new(
            elapsed_time: 0 * Job::HOUR,
            id: :hikikomi,
            after_temp: 35.0,
            room_temp: 28.0,
            room_psychrometry: nil,
          ),
          Job.new(
            elapsed_time: 1 * Job::HOUR,
            id: :tokomomi,
            after_temp: 32.0,
            room_temp: 28.0,
            room_psychrometry: nil,
          ),
          Job.new(
            elapsed_time: 9 * Job::HOUR,
            id: :kirikaeshi,
            before_temp: 32.0,
            after_temp: 31.0,
            room_temp: 28.0,
            room_psychrometry: nil,
          ),
          Job.new(
            elapsed_time: 21 * Job::HOUR,
            id: :mori,
            before_temp: 35.0,
            after_temp: 33.0,
            room_temp: 28.0,
            room_psychrometry: 4,
          ),
          Job.new(
            elapsed_time: 29 * Job::HOUR,
            id: :naka_shigoto,
            before_temp: 37.0,
            after_temp: 35.0,
            room_temp: 28.0,
            room_psychrometry: 4,
          ),
          Job.new(
            elapsed_time: 35 * Job::HOUR,
            id: :shimai_shigoto,
            before_temp: 38.0,
            after_temp: 37.0,
            room_temp: 28.0,
            room_psychrometry: 5,
          ),
          Job.new(
            elapsed_time: 39 * Job::HOUR,
            id: :tsumikae,
            after_temp: 40.0,
            room_temp: 28.0,
            room_psychrometry: 5,
          ),
          Job.new(
            elapsed_time: 44 * Job::HOUR,
            id: :dekoji,
            after_temp: 40.0,
            room_temp: 28.0,
            room_psychrometry: 5,
          ),
        ],
      }


      job_reader :hikikomi
      job_reader :tokomomi
      job_reader :kirikaeshi
      job_reader :mori
      job_reader :naka_shigoto
      job_reader :shimai_shigoto
      job_reader :tsumikae
      job_reader :dekoji


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

      def self.template(key=:default)
        new(TEMPLATES[key])
      end
    end
  end
end
