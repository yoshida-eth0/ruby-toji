module Toji
  module Brew
    HOUR = 60 * 60
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
