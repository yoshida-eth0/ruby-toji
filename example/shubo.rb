require 'toji'
require 'terminal-table'

shubo = Toji::Product::Shubo.template

table = Terminal::Table.new do |t|
  t << ["作業", "品温(度)", "ボーメ", "酸度", "経過時間", "日時"]
  t << :separator
  shubo.each {|j|
    temp = j.temps.map(&:to_s).join(" / ")
    t << [j.id, temp, j.baume, j.acid, j.elapsed_time, j.display_time]
  }
end
puts table
