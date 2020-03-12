require 'toji/recipe/ingredient/koji/base'
require 'toji/recipe/ingredient/koji/expected_fermentable'
require 'toji/recipe/ingredient/koji/expected'
require 'toji/recipe/ingredient/koji/actual_fermentable'
require 'toji/recipe/ingredient/koji/actual'

module Toji
  module Recipe
    module Ingredient
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
end
