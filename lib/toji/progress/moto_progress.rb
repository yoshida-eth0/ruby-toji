module Toji
  module Progress
    module MotoProgress
      include BaseProgress

      def all_keys
        MotoState::KEYS
      end

      def progress_note(name: nil, dash: :solid, enable_annotations: true)
        Graph::ProgressNote.new(self, name: name, dash: dash, enable_annotations: enable_annotations)
      end
    end
  end
end
