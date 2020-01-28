require 'toji'
require 'terminal-table'


moromi = Toji::Product::Moromi.template

table = Terminal::Table.new do |t|
  t << ["作業", "品温(度)", "操作室温", "ボーメ及び日本酒度", "アルコール度数", "BMD", "AB 16.5 +3", "経過時間", "日時"]
  t << :separator
  moromi.each {|j|
    temp = j.temps.map(&:to_s).join(" / ")
    t << [j.id, temp, j.room_temp, j.display_baume, j.alcohol, j.bmd&.round(2), j.expected_alcohol(16.5, +3, 1.5)&.round(2), j.elapsed_time, j.time]
  }
end
puts table
