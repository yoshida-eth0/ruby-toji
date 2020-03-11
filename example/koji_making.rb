require 'toji'
require 'terminal-table'

koji_making = Toji::KojiMaking.template

table = Terminal::Table.new do |t|
  t << ["作業", "日数", "品温(度)", "操作室温", "乾湿差(度)", "経過時間", "日時"]
  t << :separator
  koji_making.data.each {|s|
    temp = s.temps.map(&:to_s).join(" / ")
    t << [s.mark, s.day_label, temp, s.room_temp, s.room_psychrometry, s.elapsed_time, s.display_time]
  }
end
puts table
