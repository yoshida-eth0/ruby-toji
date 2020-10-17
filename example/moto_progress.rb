$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require_relative 'example_core'
require 'terminal-table'

moto = Example::Brew::MotoProgress.load_yaml_file(File.dirname(__FILE__)+"/moto_progress.yaml")

table = Terminal::Table.new do |t|
  t << ["作業", "日数", "品温(度)", "ボーメ", "酸度", "経過時間", "日時"]
  t << :separator
  moto.states.each {|s|
    temp = s.temps.map(&:to_s).join(" / ")
    t << [s.mark, s.day_label, temp, s.baume, s.acid, s.elapsed_time, s.display_time]
  }
end
puts table
