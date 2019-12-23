module Toji
  module RiceRate
    # 浸漬米吸水率
    attr_reader :soaked_rate

    # 蒸し前浸漬米吸水率
    # 炊飯の場合は水を追加
    # 蒸しの場合は一晩経って蒸発した分を削減
    attr_reader :before_steaming_rate

    # 蒸米吸水率
    attr_reader :steamed_rate

    # 放冷後蒸米吸水率
    attr_reader :cooled_rate
  end
end
