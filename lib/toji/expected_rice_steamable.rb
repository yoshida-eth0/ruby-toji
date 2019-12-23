module Toji
  module ExpectedRiceSteamable
    def soaking_water
      @raw * @soaked_rate
    end

    def soaked
      @raw + @raw * @soaked_rate
    end

    def steaming_water
      if @before_steaming_rate
        @raw * (@before_steaming_rate - @soaked_rate)
      end
    end

    def steamed
      @raw + @raw * @steamed_rate
    end

    def cooled
      @raw + @raw * @cooled_rate
    end
  end
end
