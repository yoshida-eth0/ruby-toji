module Toji
  module Brew
    class Koji < Base

      TEMPLATES = {
        default: [
          {
            elapsed_time: 0 * Brew::HOUR,
            id: :hikikomi,
            temps: 35.0,
            room_temp: 28.0,
            room_psychrometry: nil,
          },
          {
            elapsed_time: 1 * Brew::HOUR,
            id: :tokomomi,
            temps: 32.0,
            room_temp: 28.0,
            room_psychrometry: nil,
          },
          {
            elapsed_time: 9 * Brew::HOUR,
            id: :kirikaeshi,
            temps: [32.0, 31.0],
            room_temp: 28.0,
            room_psychrometry: nil,
          },
          {
            elapsed_time: 21 * Brew::HOUR,
            id: :mori,
            temps: [35.0, 33.0],
            room_temp: 28.0,
            room_psychrometry: 4,
          },
          {
            elapsed_time: 29 * Brew::HOUR,
            id: :naka_shigoto,
            temps: [37.0, 35.0],
            room_temp: 28.0,
            room_psychrometry: 4,
          },
          {
            elapsed_time: 35 * Brew::HOUR,
            id: :shimai_shigoto,
            temps: [38.0, 37.0],
            room_temp: 28.0,
            room_psychrometry: 5,
          },
          {
            elapsed_time: 39 * Brew::HOUR,
            id: :tsumikae,
            temps: 40.0,
            room_temp: 28.0,
            room_psychrometry: 5,
          },
          {
            elapsed_time: 44 * Brew::HOUR,
            id: :dekoji,
            temps: 40.0,
            room_temp: 28.0,
            room_psychrometry: 5,
          },
        ],
      }


      state_reader :hikikomi
      state_reader :tokomomi
      state_reader :kirikaeshi
      state_reader :mori
      state_reader :naka_shigoto
      state_reader :shimai_shigoto
      state_reader :tsumikae
      state_reader :dekoji


      def progress(enable_annotations: true)
        Graph::Progress.new(self, enable_annotations: enable_annotations)
      end

      def self.template(key=:default)
        create(TEMPLATES[key])
      end
    end
  end
end