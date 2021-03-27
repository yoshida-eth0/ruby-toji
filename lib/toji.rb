require "toji/version"
require 'active_support/all'
require 'yaml'

require 'toji/ingredient'
require 'toji/recipe'
require 'toji/progress'
require 'toji/calendar'
require 'toji/schedule'
require 'toji/product'
require 'toji/processing'
require 'toji/utils'

module Toji
  class Error < StandardError; end

  class DuplicateStepIndexError < Error
    attr_reader :indexes

    def initialize(indexes)
      super("step indexes is deuplicated: #{indexes.inject}")
      @indexes = indexes
    end
  end
end
