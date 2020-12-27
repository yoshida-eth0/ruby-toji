module Toji
  module Processing
    module RiceProcessing
      include Base

      # 目標値 (Toji::Ingredient::Rice)
      # @dynamic expect

      # 浸漬実績値 (Toji::Processing::SoakedRice)
      # @dynamic soaked_rice

      # 蒸米実績値 (Toji::Processing::SteamedRice)
      # @dynamic steamed_rice

      # 放冷実績値 (Toji::Processing::CooledRice)
      # @dynamic cooled_rice
    end
  end
end
