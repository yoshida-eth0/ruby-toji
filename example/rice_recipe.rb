require 'toji'
require 'terminal-table'

rice = Toji::Recipe::Ingredient::Rice.expected(100, rice_rate: Toji::Recipe::RiceRate::DEFAULT)

table = Terminal::Table.new do |t|
  t << ["", "分量", "白米を基準とした歩合"]
  t << :separator
  t << ["蒸米", rice.steamed&.round(2), (1.0 + rice.steamed_rate)&.round(2)]
  t << [" 白米", rice.raw&.round(2), 1.0]
  t << [" 汲水", rice.soaking_water&.round(2), rice.soaked_rate&.round(2)]
end
puts table
puts

table = Terminal::Table.new do |t|
  t << ["工程", "原料", "分量"]
  t << :separator
  t << ["洗米・浸漬", "白米", rice.raw&.round(2)]
  t << ["", "吸水増加量", rice.soaking_water&.round(2)]
  t << :separator
  t << ["水切り", "浸漬米", rice.soaked&.round(2)]
  t << ["", "蒸発・炊飯前の汲水", rice.steaming_water&.round(2)]
  t << :separator
  t << ["蒸し", "蒸米", rice.steamed&.round(2)]
end
puts table
