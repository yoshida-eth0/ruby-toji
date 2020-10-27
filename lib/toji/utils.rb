module Toji
  module Utils
    def self.activerecord_defined?
      Object.const_defined?(:ActiveRecord) && ActiveRecord.const_defined?(:Base)
    end

    def self.check_dup(obj)
      if activerecord_defined? && ActiveRecord::Base===obj
        if !obj.class.method_defined?(:initialize_dup, false)
          raise Error, "implementation required: #{obj.class}.initialize_dup"
        end
      else
        if !obj.class.private_method_defined?(:initialize_copy, false)
          raise Error, "implementation required: #{obj.class}.initialize_copy"
        end
      end
    end

    def self.merge_ingredients(ingredients1, ingredients2)
      result = {}

      ingredients1&.each {|src|
        dst = result[src.group_key]
        if dst
          dst.weight = dst.weight.to_f + src.weight.to_f
        else
          result[src.group_key] = src
        end
      }

      ingredients2&.each {|src|
        dst = result[src.group_key]
        if dst
          dst.weight = dst.weight.to_f + src.weight.to_f
        else
          result[src.group_key] = src.dup
        end
      }

      result.values
    end
  end
end
