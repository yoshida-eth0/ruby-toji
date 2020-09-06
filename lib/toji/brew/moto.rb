module Toji
  module Brew
    module Moto
      include Base

      def progress(name: nil, dash: :solid, enable_annotations: true)
        Graph::Progress.new(self, name: name, dash: dash, enable_annotations: enable_annotations)
      end
    end
  end
end
