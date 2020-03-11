module Toji
  class Shubo
    include Product

    TEMPLATES = {
      default: [
        {
          elapsed_time: 0 * DAY,
          mark: :mizukoji,
          temps: 12.0,
          acid: 13.0,
        },
        {
          elapsed_time: 0 * DAY + 1 * HOUR,
          mark: :shikomi,
          temps: 20.0,
          acid: 13.0,
        },
        {
          elapsed_time: 1 * DAY,
          mark: :utase,
          temps: 14.0,
          baume: 15.0,
          acid: 13.0,
        },
        {
          elapsed_time: 2 * DAY,
          temps: [8.0, 11.0],
          baume: 16.0,
          acid: 13.0,
          warming: WARM_DAKI,
        },
        {
          elapsed_time: 3 * DAY,
          temps: [10.0, 13.0],
          baume: 16.5,
          acid: 13.5,
          warming: WARM_DAKI,
        },
        {
          elapsed_time: 4 * DAY,
          temps: [12.0, 15.0],
          baume: 17.0,
          acid: 13.5,
          warming: WARM_DAKI,
        },
        {
          elapsed_time: 5 * DAY,
          temps: 14.0,
          baume: 17.0,
          acid: 14.0,
          warming: WARM_ANKA,
        },
        {
          elapsed_time: 6 * DAY,
          temps: 20.0,
          baume: 17.0,
          acid: 14.5,
          warming: WARM_ANKA,
        },
        {
          elapsed_time: 7 * DAY,
          temps: 20.0,
          baume: 14.0,
          acid: 15.5,
        },
        {
          elapsed_time: 8 * DAY,
          temps: 20.0,
          baume: 12.0,
          acid: 16.0,
        },
        {
          elapsed_time: 9 * DAY,
          mark: :wake,
          temps: 20.0,
          baume: 9.0,
          acid: 16.0,
        },
        {
          elapsed_time: 10 * DAY,
          temps: 15.0,
          baume: 8.0,
          acid: 16.5,
        },
        {
          elapsed_time: 11 * DAY,
          temps: 12.0,
          baume: 7.0,
          acid: 17.0,
        },
        {
          elapsed_time: 12 * DAY,
          temps: 10.0,
          baume: 6.0,
          acid: 17.5,
        },
        {
          elapsed_time: 13 * DAY,
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

    def initialize(data)
      self.data = data
    end

    def progress(enable_annotations: true)
      Graph::Progress.new(self, enable_annotations: enable_annotations)
    end

    def self.template(key=:default)
      create(TEMPLATES[key])
    end
  end
end
