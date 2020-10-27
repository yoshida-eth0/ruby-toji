$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require_relative 'example_core'
require 'terminal-table'

koji = Example::Koji.create(
  weight: 100,
  brand: :yamadanishiki,
  polishing_ratio: 0.55,
  made_in: :hyogo,
  year: 2020,
  soaking_ratio: 0.33,
  steaming_ratio: 0.41,
  cooling_ratio: 0.33,
  tanekojis: [
    Example::Tanekoji.create(
      brand: :byakuya,
      ratio: 0.001,
    ),
  ],
  dekoji_ratio: 0.18,
  interval_days: 0,
)

table = Terminal::Table.new do |t|
  t << ["工程", "状態", "分量/歩合"]
  t << :separator
  t << ["", "白米", koji.weight.round(2)]
  t << :separator
  t << ["洗米・浸漬", "浸漬米(g)", koji.soaked.round(2)]
  t << ["", "浸漬歩合", koji.soaking_ratio.round(2)]
  t << :separator
  t << ["蒸し", "蒸米(g)", koji.steamed.round(2)]
  t << ["", "蒸米歩合", koji.steaming_ratio.round(2)]
  t << :separator
  t << ["放冷・引込み", "蒸米(g)", koji.cooled.round(2)]
  t << ["", "蒸米歩合", koji.cooling_ratio.round(2)]
  t << ["", "種麹", koji.tanekojis.map(&:weight).sum.round(2)]
  t << :separator
  t << ["出麹", "麹(g)", koji.dekoji.round(2)]
  t << ["", "出麹歩合", koji.dekoji_ratio.round(2)]
end
puts table
