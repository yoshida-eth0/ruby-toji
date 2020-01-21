module Toji
  module Progress
    module JobAccessor
      def job_reader(*args)
        args.each {|arg|
          define_method(arg) {
            @jobs[arg]
          }
        }
      end
    end
  end
end
