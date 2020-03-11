module Toji
  module Brew
    class Shubo < Base

      TEMPLATES = {
        default: [
          {
            elapsed_time: 0 * Brew::DAY,
            mark: :mizukoji,
            temps: 12.0,
            acid: 13.0,
          },
          {
            elapsed_time: 0 * Brew::DAY + 1 * Brew::HOUR,
            mark: :shikomi,
            temps: 20.0,
            acid: 13.0,
          },
          {
            elapsed_time: 1 * Brew::DAY,
            mark: :utase,
            temps: 14.0,
            baume: 15.0,
            acid: 13.0,
          },
          {
            elapsed_time: 2 * Brew::DAY,
            temps: [8.0, 11.0],
            baume: 16.0,
            acid: 13.0,
            warming: WARM_DAKI,
          },
          {
            elapsed_time: 3 * Brew::DAY,
            temps: [10.0, 13.0],
            baume: 16.5,
            acid: 13.5,
            warming: WARM_DAKI,
          },
          {
            elapsed_time: 4 * Brew::DAY,
            temps: [12.0, 15.0],
            baume: 17.0,
            acid: 13.5,
            warming: WARM_DAKI,
          },
          {
            elapsed_time: 5 * Brew::DAY,
            temps: 14.0,
            baume: 17.0,
            acid: 14.0,
            warming: WARM_ANKA,
          },
          {
            elapsed_time: 6 * Brew::DAY,
            temps: 20.0,
            baume: 17.0,
            acid: 14.5,
            warming: WARM_ANKA,
          },
          {
            elapsed_time: 7 * Brew::DAY,
            temps: 20.0,
            baume: 14.0,
            acid: 15.5,
          },
          {
            elapsed_time: 8 * Brew::DAY,
            temps: 20.0,
            baume: 12.0,
            acid: 16.0,
          },
          {
            elapsed_time: 9 * Brew::DAY,
            mark: :wake,
            temps: 20.0,
            baume: 9.0,
            acid: 16.0,
          },
          {
            elapsed_time: 10 * Brew::DAY,
            temps: 15.0,
            baume: 8.0,
            acid: 16.5,
          },
          {
            elapsed_time: 11 * Brew::DAY,
            temps: 12.0,
            baume: 7.0,
            acid: 17.0,
          },
          {
            elapsed_time: 12 * Brew::DAY,
            temps: 10.0,
            baume: 6.0,
            acid: 17.5,
          },
          {
            elapsed_time: 13 * Brew::DAY,
            temps: 9.0,
            baume: 5.0,
            acid: 17.5,
          },
        ],
      }


      state_reader :mizukoji
      state_reader :shikomi
      state_reader :utase
      state_reader :wake

      def progress(enable_annotations: true)
        Graph::Progress.new(self, enable_annotations: enable_annotations)
      end

      def self.template(key=:default)
        create(TEMPLATES[key])
      end
    end
  end
end
