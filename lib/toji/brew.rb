module Toji
  module Brew
    HOUR = 60 * 60
    DAY = 24 * HOUR

    WARM_DAKI = 1
    WARM_ANKA = 1<<1
    WARM_MAT = 1<<2
  end
end

require 'toji/brew/state_accessor'
require 'toji/brew/base'
require 'toji/brew/state'
require 'toji/brew/state_record'
require 'toji/brew/builder'
require 'toji/brew/graph'

require 'toji/brew/koji'
require 'toji/brew/shubo'
require 'toji/brew/moromi'
