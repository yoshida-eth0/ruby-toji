require 'toji/material/koji/base'
require 'toji/material/koji/expected_fermentable'
require 'toji/material/koji/expected'
require 'toji/material/koji/actual_fermentable'
require 'toji/material/koji/actual'

module Toji
  module Material
    module Koji
      def self.expected(raw, rice_rate: Recipe::RiceRate::Cooked::DEFAULT, koji_rate: Recipe::KojiRate::DEFAULT)
        Expected.new(raw, rice_rate: rice_rate, koji_rate: koji_rate)
      end

      def self.actual(raw, soaked, steaming_water, steamed, cooled, tanekoji, dekoji)
        Actual.new(raw, soaked, steaming_water, steamed, cooled, tanekoji, dekoji)
      end
    end
  end
end
