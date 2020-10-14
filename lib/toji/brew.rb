module Toji
  module Brew
    SECOND = 1
    MINUTE = 60 * SECOND
    HOUR = 60 * MINUTE
    DAY = 24 * HOUR
  end
end

require 'toji/brew/state'
require 'toji/brew/base_state'
require 'toji/brew/koji_state'
require 'toji/brew/moto_state'
require 'toji/brew/moromi_state'

require 'toji/brew/progress'
require 'toji/brew/base_progress'
require 'toji/brew/koji_progress'
require 'toji/brew/moto_progress'
require 'toji/brew/moromi_progress'

require 'toji/brew/builder'
require 'toji/brew/graph'
