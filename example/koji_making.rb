require 'toji'
require 'terminal-table'

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
