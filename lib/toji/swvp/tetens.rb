require 'toji/swvp/base'

module Toji
  module Swvp

    # Tetensの式
    class Tetens
      include Base
      include Singleton
  
      def calc(temp)
        temp = temp.to_f
        6.11 * 10 ** ((7.5 * temp) / (237.3 + temp))
      end 
    end 
  end
end
