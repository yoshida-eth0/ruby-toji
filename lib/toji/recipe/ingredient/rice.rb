require 'toji/recipe/ingredient/rice/base'
require 'toji/recipe/ingredient/rice/expected_steamable'
require 'toji/recipe/ingredient/rice/expected'
require 'toji/recipe/ingredient/rice/actual_steamable'
require 'toji/recipe/ingredient/rice/actual'

module Toji
  module Recipe
    module Ingredient
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
end
