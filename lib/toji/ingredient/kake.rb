require 'toji/ingredient/kake/base'
require 'toji/ingredient/kake/expected'
require 'toji/ingredient/kake/actual'

module Toji
  module Ingredient
    module Kake
      def self.expected(raw, rice_rate: Recipe::RiceRate::DEFAULT)
        Expected.new(raw, rice_rate: rice_rate)
      end

      def self.actual(raw, soaked, steaming_water, steamed, cooled)
        Actual.new(raw, soaked, steaming_water, steamed, cooled)
      end
    end
  end
end
