module Toji
  module Brew
    module Statable
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

      def temps=(val)
        @temps = [val].flatten.compact.map(&:to_f)
      end

      def time=(val)
        @time = val&.to_time
      end

      def warmings=(val)
        @warmings = [val].flatten.compact
      end
    end
  end
end
