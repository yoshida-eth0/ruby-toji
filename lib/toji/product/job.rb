module Toji
  module Product
    class Job
      HOUR = 60 * 60
      DAY = 24 * HOUR

      WARM_DAKI = 1
      WARM_ANKA = 1<<1
      WARM_MAT = 1<<2

      attr_accessor :jobs

      attr_accessor :time
      attr_accessor :elapsed_time
      attr_accessor :id
      attr_accessor :before_temp
      attr_accessor :after_temp

      attr_accessor :preset_temp
      attr_accessor :room_temp
      attr_accessor :room_psychrometry

      attr_accessor :baume
      attr_accessor :nihonshudo
      attr_accessor :acid
      attr_accessor :amino_acid
      attr_accessor :alcohol

      attr_accessor :warming
      attr_accessor :note

      def initialize(
        time: nil, elapsed_time: nil, id: nil, before_temp: nil, after_temp: nil,
        preset_temp: nil, room_temp: nil, room_psychrometry: nil,
        baume: nil, nihonshudo: nil, acid: nil, amino_acid: nil, alcohol: nil,
        warming: nil, note: nil)
        @time = time
        @elapsed_time = elapsed_time
        @id = id
        @before_temp = before_temp
        @after_temp = after_temp

        @preset_temp = preset_temp
        @room_temp = room_temp
        @room_psychrometry = room_psychrometry

        @baume = baume
        @nihonshudo = nihonshudo
        @acid = acid
        @amino_acid = amino_acid
        @alcohol = alcohol

        @warming = warming
        @note = note
      end

      def temps
        result = []

        if @before_temp
          result << @before_temp
        end

        if @after_temp
          result << @after_temp
        end

        result
      end

      def baume
        if @baume
          @baume
        elsif @nihonshudo
          @nihonshudo * -0.1
        end
      end

      def nihonshudo
        if @nihonshudo
          @nihonshudo
        elsif @baume
          @baume * -10
        else
          nil
        end
      end

      def display_baume
        if @baume || @nihonshudo
          b = baume
          if b<3.0
            nihonshudo
          else
            b
          end
        end
      end

      def display_time(format="%m/%d %H:%M")
        if @time
          time.strftime(format)
        else
          Time.at(elapsed_time).strftime(format)
        end
      end

      def moromi_time
        tome = jobs[:tome]
        if tome
          time = elapsed_time - tome.elapsed_time
          if 0<time
            return time
          end
        end
        nil
      end

      def moromi_day
        moromi_t = moromi_time
        if moromi_t
          (moromi_t.to_f / Job::DAY).floor + 1
        end
      end

      def bmd
        _moromi_day = moromi_day
        _baume = baume

        if _moromi_day && _baume
          _moromi_day * _baume
        end
      end

      def warmings
        result = []
        if @warming & WARM_DAKI
          result << :daki
        end
        if @warming & WARM_ANKA
          result << :anka
        end
        if @warming & WARM_MAT
          result << :mat
        end
        result
      end

      def to_h
        {
          time: time,
          elapsed_time: elapsed_time,
          display_time: display_time,
          id: id,
          preset_temp: preset_temp,
          before_temp: before_temp,
          after_temp: after_temp,
          temps: temps,
          room_temp: room_temp,
          room_psychrometry: room_psychrometry,
          baume: baume,
          nihonshudo: nihonshudo,
          acid: acid,
          amino_acid: amino_acid,
          alcohol: alcohol,
          warmings: warmings,
          moromi_day: moromi_day,
          bmd: bmd,
          note: note,
        }
      end
    end
  end
end
