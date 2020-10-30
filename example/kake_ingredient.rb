$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require_relative 'example_core'
require 'terminal-table'

kake = Example::Kake.create(
  weight: 100,
  brand: :yamadanishiki,
  polishing_ratio: 0.55,
  made_in: :hyogo,
  year: 2020,
  soaking_ratio: 0.33,
  steaming_ratio: 0.41,
  cooling_ratio: 0.33,
  interval_days: 0,
)

table = Terminal::Table.new do |t|
  t << ["工程", "状態", "分量/歩合"]
  t << :separator
  t << ["", "白米", kake.weight.round(2)]
  t << :separator
  t << ["洗米・浸漬", "浸漬米(g)", kake.soaked.round(2)]
  t << ["", "浸漬米吸水率", kake.soaking_ratio.round(2)]
  t << :separator
  t << ["蒸し", "蒸米(g)", kake.steamed.round(2)]
  t << ["", "蒸米吸水率", kake.steaming_ratio.round(2)]
  t << :separator
  t << ["放冷", "蒸米(g)", kake.cooled.round(2)]
  t << ["", "蒸米吸水率", kake.cooling_ratio.round(2)]
end
puts table
