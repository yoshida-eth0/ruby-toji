require 'toji/swvp/base'
require 'toji/swvp/tetens'
require 'toji/swvp/wagner'
require 'toji/swvp/sonntag'

module Toji
  # 飽和水蒸気圧 SWVP: saturation water vapor pressure
  module Swvp
    cattr_accessor :default
    self.default = Wagner.instance
  end
end
