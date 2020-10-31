module Toji
  module Progress
    SECOND = 1
    MINUTE = 60 * SECOND
    HOUR = 60 * MINUTE
    DAY = 24 * HOUR
  end
end

require 'toji/progress/state'
require 'toji/progress/base_state'
require 'toji/progress/koji_state'
require 'toji/progress/moto_state'
require 'toji/progress/moromi_state'

require 'toji/progress/progress'
require 'toji/progress/base_progress'
require 'toji/progress/koji_progress'
require 'toji/progress/moto_progress'
require 'toji/progress/moromi_progress'

require 'toji/progress/builder'
require 'toji/progress/graph'
