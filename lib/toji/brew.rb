module Toji
  module Brew
    SECOND = 1
    MINUTE = 60 * SECOND
    HOUR = 60 * MINUTE
    DAY = 24 * HOUR
  end
end

require 'toji/brew/base'
require 'toji/brew/state_wrapper'
require 'toji/brew/state'
require 'toji/brew/builder'
require 'toji/brew/graph'

require 'toji/brew/koji'
require 'toji/brew/shubo'
require 'toji/brew/moromi'
