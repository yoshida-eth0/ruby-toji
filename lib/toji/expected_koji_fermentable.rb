module Toji
  module ExpectedKojiFermentable
    def tanekoji
      @raw * @tanekoji_rate
    end

    def dekoji
      @raw + @raw * @dekoji_rate
    end
  end
end
