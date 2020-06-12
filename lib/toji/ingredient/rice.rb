require 'toji/ingredient/rice/base'
require 'toji/ingredient/rice/expected_steamable'
require 'toji/ingredient/rice/expected'
require 'toji/ingredient/rice/actual_steamable'
require 'toji/ingredient/rice/actual'

module Toji
  module Ingredient
    module Rice
      def self.expected(raw, rice_rate: Recipe::RiceRate::DEFAULT)
        Expected.new(raw, rice_rate: rice_rate)
      end

      def self.actual(raw, soaked, steaming_water, steamed, cooled)
        Actual.new(raw, soaked, steaming_water, steamed, cooled)
      end
    end
  end
end
