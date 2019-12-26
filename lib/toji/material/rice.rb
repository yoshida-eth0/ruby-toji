require 'toji/material/rice/base'
require 'toji/material/rice/expected_steamable'
require 'toji/material/rice/expected'
require 'toji/material/rice/actual_steamable'
require 'toji/material/rice/actual'

module Toji
  module Material
    module Rice
      def self.expected(raw, rice_rate: Recipe::RiceRate::Cooked::DEFAULT)
        Expected.new(raw, rice_rate: rice_rate)
      end

      def self.actual(raw, soaked, steaming_water, steamed, cooled)
        Actual.new(raw, soaked, steaming_water, steamed, cooled)
      end
    end
  end
end
