module Toji
  module Brew
    module Moromi
      include Base

      attr_accessor :prefix_day_labels

      def moromi_tome_day
        prefix_day_labels&.length
      end

      def moromi_days
        _tome_day = moromi_tome_day
        _days = self.days

        if _tome_day && _tome_day<_days
          _days - _tome_day + 1
        end
      end

      def day_labels
        _prefix = prefix_day_labels

        if _prefix
          _prefix + moromi_days.times.map{|i| i+2}.map(&:to_s)
        else
          super
        end
      end

      def progress(name: nil, dash: :solid, enable_annotations: true)
        Graph::Progress.new(self, name: name, dash: dash, enable_annotations: enable_annotations)
      end

      def bmd
        Graph::Bmd.new.actual(self)
      end

      def ab(coef, expects=[])
        Graph::Ab.new.coef(coef).actual(self).expects(expects)
      end
    end
  end
end
