$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require 'terminal-table'

koji = Toji::Ingredient::Koji.expected(100, rice_ratio: Toji::Ingredient::RiceRate::DEFAULT, koji_ratio: Toji::Ingredient::KojiRate::DEFAULT)

table = Terminal::Table.new do |t|
  t << ["", "分量", "白米を基準とした歩合"]
  t << :separator
  t << ["麹", koji.dekoji&.round(2), (1.0 + koji.dekoji_ratio)&.round(2)]
  t << [" 蒸米", koji.steamed&.round(2), (1.0 + koji.steaming_ratio)&.round(2)]
  t << ["  白米", koji.weight&.round(2), 1.0]
  t << ["  汲水", koji.soaking_water&.round(2), koji.soaking_ratio&.round(2)]
  t << [" 種麹", koji.tanekoji&.round(2), koji.tanekoji_ratio&.round(2)]
end
puts table
puts

table = Terminal::Table.new do |t|
  t << ["工程", "原料", "分量"]
  t << :separator
  t << ["洗米・浸漬", "白米", koji.weight&.round(2)]
  t << ["", "吸水増加量", koji.soaking_water&.round(2)]
  t << :separator
  t << ["水切り", "浸漬米", koji.soaked&.round(2)]
  t << :separator
  t << ["蒸し", "蒸米", koji.steamed&.round(2)]
  t << :separator
  t << ["放冷・引込み", "蒸米", koji.cooled&.round(2)]
  t << ["", "種麹", koji.tanekoji&.round(2)]
  t << :separator
  t << ["製麹", "麹", koji.dekoji&.round(2)]
end
puts table
