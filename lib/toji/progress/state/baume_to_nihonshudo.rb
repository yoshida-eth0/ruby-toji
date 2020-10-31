module Toji
  module Progress
    module State
      module BaumeToNihonshudo
        def nihonshudo
          if self.baume
            self.baume * -10
          end
        end

        def nihonshudo=(val)
          if val
            self.baume = val.to_f / -10.0
          else
            self.baume = nil
          end
        end
      end
    end
  end
end
