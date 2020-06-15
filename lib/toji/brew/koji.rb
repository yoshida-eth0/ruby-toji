module Toji
  module Brew
    class Koji < Base

      def progress(name: nil, dash: :solid, enable_annotations: true)
        Graph::Progress.new(self, name: name, dash: dash, enable_annotations: enable_annotations)
      end
    end
  end
end
