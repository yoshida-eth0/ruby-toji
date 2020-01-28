require 'toji'
require 'terminal-table'

rice_rate = Toji::Recipe::RiceRate.cooked(0.30, 0.45, 0.40, 0.37)
koji = Toji::Ingredient::Koji.expected(200.0, rice_rate: rice_rate)
#koji = Toji::Ingredient::Koji.actual(200.0, 266.0, 24.0, 280.0, 270, 0.2, 0.0)

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
  t << ["洗米・浸漬", "白米", koji.raw&.round(2)]
  t << ["", "吸水増加量", koji.soaking_water&.round(2)]
  t << :separator
  t << ["水切り", "浸漬米", koji.soaked&.round(2)]
  t << ["", "蒸発・炊飯前の汲水", koji.steaming_water&.round(2)]
  t << :separator
  t << ["蒸し", "蒸米", koji.steamed&.round(2)]
  t << :separator
  t << ["放冷・引込み", "蒸米", koji.cooled&.round(2)]
  t << ["", "種麹", koji.tanekoji&.round(2)]
  t << :separator
  t << ["製麹", "麹", koji.dekoji&.round(2)]
end
puts table


koji_making = Toji::Product::KojiMaking.template

table = Terminal::Table.new do |t|
  t << ["作業", "品温(度)", "操作室温", "乾湿差(度)", "経過時間", "日時"]
  t << :separator
  koji_making.each {|j|
    temp = j.temps.map(&:to_s).join(" / ")
    t << [j.id, temp, j.room_temp, j.room_psychrometry, j.elapsed_time, j.display_time]
  }
end
puts table


koji_making = Toji::Product::KojiMaking.template
koji_making.add(Toji::Product::Job.new(
  time: Time.mktime(2020, 1, 15, 13, 15),
  id: :hikikomi,
  temps: 31.2,
  preset_temp: 35,
  room_temp: 25,
))

table = Terminal::Table.new do |t|
  t << ["作業", "品温(度)", "操作室温", "設定温度", "経過時間", "日時"]
  t << :separator
  koji_making.each {|j|
    temp = j.temps.map(&:to_s).join(" / ")
    t << [j.id, temp, j.room_temp, j.preset_temp, j.elapsed_time, j.display_time]
  }
end
puts table
