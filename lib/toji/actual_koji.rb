module Toji
  class ActualKoji
    include Koji
    include ActualRiceSteamable
    include ActualKojiFermentable

    def initialize(raw, soaked, steaming_water, steamed, cooled, tanekoji, dekoji)
      @raw = raw
      @soaked = soaked
      @steaming_water = steaming_water
      @steamed = steamed
      @cooled = cooled
      @tanikoji = tanekoji
      @dekoji = dekoji
    end
  end
end
