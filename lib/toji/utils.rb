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
  end
end
