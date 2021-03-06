$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require_relative 'example_core'
require 'terminal-table'


moromi = Example::Progress::MoromiProgress.load_yaml_file(File.dirname(__FILE__)+"/moromi_progress.yaml")

table = Terminal::Table.new do |t|
  t << ["作業", "日数", "品温(度)", "操作室温", "ボーメ及び日本酒度", "アルコール度数", "BMD", "アルコール期待値(16.5 +3)", "経過時間", "日時"]
  t << :separator
  moromi.states.each {|s|
    temp = s.temps.map(&:to_s).join(" / ")
    t << [s.mark, s.day_label, temp, s.room_dry_temp, s.display_baume, s.alcohol, s.bmd&.round(2), s.expected_alcohol(16.5, +3, 1.5)&.round(2), s.elapsed_time, s.display_time]
  }
end
puts table
