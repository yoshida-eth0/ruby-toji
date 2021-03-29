require 'toji/swvp/base'

module Toji
  module Swvp

    # Sonntagの式
    class Sonntag
      include Base
      include Singleton
  
      A = -6096.9385
      B = 21.2409642
      C = 2.711193 * 10**-2
      D = 1.673852 * 10**-5
      E = 2.433502
  
      def calc(temp)
        temp = temp.to_f
        (Math.exp(A * ((temp + 273.15)**-1) + B - C * (temp + 273.15) + D * ((temp + 273.15)**2) + E * Math.log(temp + 273.15))) / 100 
      end 
    end 
  end
end
