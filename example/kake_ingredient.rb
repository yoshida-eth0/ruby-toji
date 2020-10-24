$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require 'terminal-table'

kake = Toji::Ingredient::Kake.expected(100, rice_ratio: Toji::Ingredient::RiceRate::DEFAULT)

table = Terminal::Table.new do |t|
  t << ["", "分量", "白米を基準とした歩合"]
  t << :separator
  t << ["蒸米", kake.steamed&.round(2), (1.0 + kake.steaming_ratio)&.round(2)]
  t << [" 白米", kake.weight&.round(2), 1.0]
  t << [" 汲水", kake.soaking_water&.round(2), kake.soaking_ratio&.round(2)]
end
puts table
puts

table = Terminal::Table.new do |t|
  t << ["工程", "原料", "分量"]
  t << :separator
  t << ["洗米・浸漬", "白米", kake.weight&.round(2)]
  t << ["", "吸水増加量", kake.soaking_water&.round(2)]
  t << :separator
  t << ["水切り", "浸漬米", kake.soaked&.round(2)]
  t << :separator
  t << ["蒸し", "蒸米", kake.steamed&.round(2)]
end
puts table
