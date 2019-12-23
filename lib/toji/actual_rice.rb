module Toji
  class ActualRice
    include Rice
    include ActualRiceSteamable

    def initialize(raw, soaked, steaming_water, steamed, cooled)
      @raw = raw
      @soaked = soaked
      @steaming_water = steaming_water
      @steamed = steamed
      @cooled = cooled
    end
  end
end
