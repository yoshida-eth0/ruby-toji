module Toji
  module Utils
    def self.activemodel_defined?
      Object.const_defined?(:ActiveModel) && ActiveModel.const_defined?(:Validations)
    end

    def self.check_dup(obj)
      if activemodel_defined? && ActiveModel::Validations===obj
        # ok
      else
        if !obj.class.private_method_defined?(:initialize_copy, false)
          raise Error, "implementation required: #{obj.class}.initialize_copy"
        end
      end
    end

    def self.merge_ingredients(ingredients1, ingredients2)
      result = {}

      ingredients1&.each {|src|
        dst = result[src.ingredient_key]
        if dst
          dst.weight = dst.weight.to_f + src.weight.to_f
        else
          result[src.ingredient_key] = src
        end
      }

      ingredients2&.each {|src|
        dst = result[src.ingredient_key]
        if dst
          dst.weight = dst.weight.to_f + src.weight.to_f
        else
          result[src.ingredient_key] = src.dup
        end
      }

      result.values
    end
  end
end
