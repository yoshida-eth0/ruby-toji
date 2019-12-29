module Toji
  module Progress
    module MakeKoji
      module Base
        attr_reader :hikikomi
        attr_reader :tokomomi
        attr_reader :kirikaeshi
        attr_reader :mori
        attr_reader :naka_shigoto
        attr_reader :shimai_shigoto
        attr_reader :tsumikae
        attr_reader :dekoji

        def hikikomi
          @jobs[:hikikomi]
        end

        def tokomomi
          @job[:tokomomi]
        end

        def kirikaeshi
          @job[:kirikaeshi]
        end

        def mori
          @job[:mori]
        end

        def naka_shigoto
          @job[:naka_shigoto]
        end

        def shimai_shigoto
          @job[:shimai_shigoto]
        end

        def tsumikae
          @job[:tsumikae]
        end

        def dekoji
          @job[:dekoji]
        end
      end
    end
  end
end
