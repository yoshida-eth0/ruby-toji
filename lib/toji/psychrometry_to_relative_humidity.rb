require 'toji/swvp'

module Toji
  # 乾湿差から相対湿度へ変換
  class PsychrometryToRelativeHumidity
    attr_reader :swvp
    attr_reader :pressure
    attr_reader :k

    def initialize(swvp: Swvp.default, pressure: 1013, k: 0.000662)
      @swvp = swvp
      @pressure = pressure
      @k = k
    end

    def convert(t_wet, t_dry)
      p_wet = swvp.calc(t_wet)
      p_dry = swvp.calc(t_dry)

      p_w = p_wet - pressure * k * (t_dry - t_wet)
      p_w / p_dry
    end
  end
end
