module Toji
  module Product
    class KojiMaking < Base

      TEMPLATES = {
        default: [
          Job.new(
            elapsed_time: 0 * Job::HOUR,
            id: :hikikomi,
            temps: 35.0,
            room_temp: 28.0,
            room_psychrometry: nil,
          ),
          Job.new(
            elapsed_time: 1 * Job::HOUR,
            id: :tokomomi,
            temps: 32.0,
            room_temp: 28.0,
            room_psychrometry: nil,
          ),
          Job.new(
            elapsed_time: 9 * Job::HOUR,
            id: :kirikaeshi,
            temps: [32.0, 31.0],
            room_temp: 28.0,
            room_psychrometry: nil,
          ),
          Job.new(
            elapsed_time: 21 * Job::HOUR,
            id: :mori,
            temps: [35.0, 33.0],
            room_temp: 28.0,
            room_psychrometry: 4,
          ),
          Job.new(
            elapsed_time: 29 * Job::HOUR,
            id: :naka_shigoto,
            temps: [37.0, 35.0],
            room_temp: 28.0,
            room_psychrometry: 4,
          ),
          Job.new(
            elapsed_time: 35 * Job::HOUR,
            id: :shimai_shigoto,
            temps: [38.0, 37.0],
            room_temp: 28.0,
            room_psychrometry: 5,
          ),
          Job.new(
            elapsed_time: 39 * Job::HOUR,
            id: :tsumikae,
            temps: 40.0,
            room_temp: 28.0,
            room_psychrometry: 5,
          ),
          Job.new(
            elapsed_time: 44 * Job::HOUR,
            id: :dekoji,
            temps: 40.0,
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


      def initialize(jobs=[], date_line: 0)
        super(jobs, date_line: date_line)
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
