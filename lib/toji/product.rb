require 'toji/product/schedule_factory'

module Toji
  module Product
    attr_reader :name
    attr_reader :recipe
    attr_reader :base_date

    attr_reader :koji_schedules
    attr_reader :kake_schedules
    attr_reader :action_schedules

    def rice_schedules
      koji_schedules + kake_schedules
    end

    def schedules
      rice_schedules + action_schedules
    end
  end
end
