require 'toji'
require 'terminal-table'

make_koji = Toji::Progress::MakeKoji.template

table = Terminal::Table.new do |t|
  t << ["作業", "品温(度)", "操作室温", "乾湿差(度)", "経過時間"]
  t << :separator
  make_koji.jobs.each {|j|
    if j.before_temp && j.after_temp
      temp = "%s / %s" % [j.before_temp, j.after_temp]
    else
      temp = j.before_temp || j.after_temp
    end
    t << [j.id, temp, j.room_temp, j.room_psychrometry, j.elapsed_time]
  }
end
puts table
