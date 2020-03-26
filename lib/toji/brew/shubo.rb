module Toji
  module Brew
    class Shubo < Base

      state_reader :mizukoji
      state_reader :shikomi
      state_reader :utase
      state_reader :wake

      def progress(enable_annotations: true)
        Graph::Progress.new(self, enable_annotations: enable_annotations)
      end
    end
  end
end
