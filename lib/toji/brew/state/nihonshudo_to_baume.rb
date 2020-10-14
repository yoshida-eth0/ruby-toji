module Toji
  module Brew
    module State
      module NihonshudoToBaume
        def baume
          if self.nihonshudo
            self.nihonshudo / -10.0
          end
        end

        def baume=(val)
          if val
            self.nihonshudo = val.to_f * -10
          else
            self.nihonshudo = nil
          end
        end
      end
    end
  end
end
