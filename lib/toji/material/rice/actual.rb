module Toji
  module Material
    module Rice
      class ActualRice
        include Base
        include ActualSteamable

        def initialize(raw, soaked, steaming_water, steamed, cooled)
          @raw = raw
          @soaked = soaked
          @steaming_water = steaming_water
          @steamed = steamed
          @cooled = cooled
        end
      end
    end
  end
end
