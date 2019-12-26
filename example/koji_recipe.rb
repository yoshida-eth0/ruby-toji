require 'toji'
require 'terminal-table'

koji = Toji::Material::Koji.expected(100, rice_rate: Toji::Recipe::RiceRate::Steamed::DEFAULT, koji_rate: Toji::Recipe::KojiRate::DEFAULT)

table = Terminal::Table.new do |t|
  t << ["", "分量", "白米を基準とした歩合"]
  t << :separator
  t << ["麹", koji.dekoji, 1.0 + koji.dekoji_rate]
  t << [" 蒸米", koji.steamed, 1.0 + koji.steamed_rate]
  t << ["  白米", koji.raw, 1.0]
  t << ["  汲水", koji.soaking_water, koji.soaked_rate]
  t << [" 種麹", koji.tanekoji, koji.tanekoji_rate]
end
puts table
puts

table = Terminal::Table.new do |t|
  t << ["工程", "原料", "分量"]
  t << :separator
  t << ["洗米・浸漬", "白米", koji.raw]
  t << ["", "吸水増加量", koji.soaking_water]
  t << :separator
  t << ["水切り", "浸漬米", koji.soaked]
  t << ["", "蒸発・炊飯前の汲水", koji.steaming_water]
  t << :separator
  t << ["蒸し", "蒸米", koji.steamed]
  t << :separator
  t << ["放冷・引込み", "蒸米", koji.cooled]
  t << ["", "種麹", koji.tanekoji]
  t << :separator
  t << ["製麹", "麹", koji.dekoji]
end
puts table
