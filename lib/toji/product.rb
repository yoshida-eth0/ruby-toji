require 'toji/product/schedule_factory'

module Toji
  module Product
    attr_accessor :name
    attr_accessor :recipe
    attr_accessor :base_date

    attr_accessor :koji_schedules
    attr_accessor :kake_schedules
    attr_accessor :action_schedules

    def rice_schedules
      koji_schedules + kake_schedules
    end

    def schedules
      rice_schedules + action_schedules
    end
  end
end
