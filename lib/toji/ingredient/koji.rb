require 'toji/ingredient/koji/base'
require 'toji/ingredient/koji/expected_fermentable'
require 'toji/ingredient/koji/expected'
require 'toji/ingredient/koji/actual_fermentable'
require 'toji/ingredient/koji/actual'

module Toji
  module Ingredient
    module Koji
      def self.expected(raw, rice_rate: Recipe::RiceRate::DEFAULT, koji_rate: Recipe::KojiRate::DEFAULT)
        Expected.new(raw, rice_rate: rice_rate, koji_rate: koji_rate)
      end

      def self.actual(raw, soaked, steaming_water, steamed, cooled, tanekoji, dekoji)
        Actual.new(raw, soaked, steaming_water, steamed, cooled, tanekoji, dekoji)
      end
    end
  end
end
