require 'toji/product/schedule_factory'

module Toji
  module Product
    # @dynamic name
    # @dynamic recipe
    # @dynamic base_date

    # @dynamic koji_schedules
    # @dynamic kake_schedules
    # @dynamic action_schedules

    def rice_schedules
      koji_schedules + kake_schedules
    end

    def schedules
      rice_schedules + action_schedules
    end
  end
end
