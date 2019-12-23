module Toji
  class KojiRate
    attr_reader :tanekoji_rate
    attr_reader :dekoji_rate

    def initialize(tanekoji_rate, dekoji_rate)
      @tanekoji_rate = tanekoji_rate
      @dekoji_rate = dekoji_rate
    end

    DEFAULT = new(0.001, 0.18)
  end
end
