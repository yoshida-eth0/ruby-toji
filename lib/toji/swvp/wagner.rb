require 'toji/swvp/base'

module Toji
  module Swvp

    # Wagnerの式
    class Wagner
      include Base
      include Singleton
  
      Pc = 221200 # hPa：臨界圧
      Tc = 647.3  # K：臨界温度
      A = -7.76451
      B = 1.45838
      C = -2.7758
      D = -1.2303
  
      def calc(temp)
        x = 1 - (temp.to_f + 273.15) / Tc
        Pc * Math.exp((A * x + B * x**1.5 + C * x**3 + D * x**6) / (1 - x)) 
      end 
    end 

  end
end
