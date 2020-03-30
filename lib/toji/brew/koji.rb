module Toji
  module Brew
    class Koji < Base

      state_reader :hikikomi
      state_reader :tokomomi
      state_reader :kirikaeshi
      state_reader :mori
      state_reader :naka_shigoto
      state_reader :shimai_shigoto
      state_reader :tsumikae
      state_reader :dekoji


      def progress(name: nil, dash: :solid, enable_annotations: true)
        Graph::Progress.new(self, name: name, dash: dash, enable_annotations: enable_annotations)
      end
    end
  end
end
