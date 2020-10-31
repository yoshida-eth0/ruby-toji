module Toji
  module Processing
    module RiceProcessing
      include Base

      # 目標値 (Toji::Ingredient::Rice)
      attr_reader :expect

      # 浸漬実績値 (Toji::Processing::SoakedRice)
      attr_reader :soaked_rice

      # 蒸米実績値 (Toji::Processing::SteamedRice)
      attr_reader :steamed_rice

      # 放冷実績値 (Toji::Processing::CooledRice)
      attr_reader :cooled_rice
    end
  end
end
