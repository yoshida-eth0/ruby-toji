require 'toji/product/schedule_factory'

module Toji
  module Product
    # @dynamic serial_num
    # @dynamic recipe
    # @dynamic base_date
    # @dynamic base_date=

    # @dynamic koji_schedules
    # @dynamic kake_schedules
    # @dynamic action_schedules
    # @dynamic rice_schedules
    # @dynamic schedules

    def compact!
      recipe&.compact!

      min_interval_days = [
        recipe&.steps&.map(&:interval_days)&.min,
        recipe&.steps&.flat_map{|step| step.rices.to_a}&.map(&:interval_days)&.min,
        recipe&.actions&.map(&:interval_days)&.min,
      ].compact.min

      if min_interval_days && min_interval_days!=0
        recipe&.steps&.each {|step|
          step.interval_days -= min_interval_days
          step.rices {|rice|
            rice.interval_days -= min_interval_days
          }
        }
        recipe&.actions&.each {|action|
          action.interval_days -= min_interval_days
        }
        self.base_date = base_date.since(min_interval_days.days)
      end

      self
    end

    def compact
      Utils.check_dup(self)

      dst = self.dup
      dst.compact!
    end
  end
end
