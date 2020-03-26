module Toji
  module Brew
    class Moromi < Base

      state_reader :moto
      state_reader :soe
      state_reader :naka
      state_reader :tome
      state_reader :yodan

      attr_writer :prefix_day_labels

      def prefix_day_labels
        if @prefix_day_labels
          @prefix_day_labels
        elsif !self[:soe] && !self[:tome]
          nil
        else
          labels = []
          [:soe, :naka, :tome].each {|mark|
            s = self[mark]
            if s
              i = s.day - 1
              labels[i] = mark
            end
          }

          soe_i = labels.index(:soe)
          labels.map.with_index {|label,i|
            if label
              label
            elsif !soe_i || i<soe_i
              :moto
            else
              :odori
            end
          }
        end
      end

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
          _prefix + moromi_days.times.map{|i| i+2}
        else
          self.days.times.map{|i| i+1}
        end
      end

      def progress(enable_annotations: true)
        Graph::Progress.new(self, enable_annotations: enable_annotations)
      end

      def bmd
        Graph::Bmd.new.actual(self)
      end

      def ab(coef=1.5)
        Graph::Ab.new(coef).actual(self)
      end
    end
  end
end
