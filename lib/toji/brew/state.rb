module Toji
  module Brew
    module State
      KEYS = [
        :time,
        :elapsed_time,
        :mark,
        :temps,
        :preset_temp,
        :room_temp,
        :room_psychrometry,
        :baume,
        :nihonshudo,
        :acid,
        :amino_acid,
        :alcohol,
        :warmings,
        :note,
      ].freeze

      attr_accessor :time
      attr_accessor :elapsed_time
      attr_accessor :mark
      attr_accessor :temps

      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry

      attr_accessor :baume
      attr_accessor :nihonshudo
      attr_accessor :acid
      attr_accessor :amino_acid
      attr_accessor :alcohol

      attr_accessor :warmings
      attr_accessor :note


      def self.included(cls)
        cls.prepend PrependMethods
      end

      module PrependMethods
        def temps=(val)
          super([val].flatten.compact.map(&:to_f))
        end

        def time=(val)
          super(val&.to_time)
        end

        def warmings=(val)
          super([val].flatten.compact)
        end
      end

      def self.create(val)
        if State===val
          val
        elsif StateWrapper==val
          val.state
        elsif Hash===val
          #s = Class.new {
          #  include State
          #}.new
          s = Object.new.tap {|o|
            o.extend State
            o.extend State::PrependMethods
          }

          KEYS.each {|k|
            s.send("#{k}=", val[k])
          }
          s
        else
          raise Error, "ArgumentError: cant cast to Toji::Brew::State"
        end
      end
    end
  end
end
