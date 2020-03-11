module Toji
  module Brew
    module StateAccessor
      def state_reader(*args)
        args.each {|arg|
          define_method(arg) {
            @data[arg]
          }
        }
      end
    end
  end
end
