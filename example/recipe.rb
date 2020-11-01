$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require_relative 'example_core'
require 'terminal-table'

recipe = Example::Recipe::TEMPLATES[:sokujo_nada].scale_rice_total(900).round(2)
step_names = ["酛", "添", "仲", "留", "四段"].slice(0, recipe.steps.length)

table = Terminal::Table.new do |t|
  t << [""] + step_names
  t << :separator
  t << ["[原料]"]
  t << ["酵母(g or 本)"] + recipe.steps.map{|s| s.yeasts.map(&:weight).sum}
  t << ["乳酸(ml)"] + recipe.steps.map{|s| s.lactic_acids.map(&:weight).sum}
  t << ["掛米(g)"] + recipe.steps.map(&:kake_total)
  t << ["麹米(g)"] + recipe.steps.map(&:koji_total)
  t << ["汲水(ml)"] + recipe.steps.map(&:water_total)
  t << ["醸造アルコール(ml)"] + recipe.steps.map{|s| s.alcohols.map(&:weight).sum}
  t << :separator
  t << ["[合計]"]
  t << ["総米(g)"] + recipe.steps.map(&:rice_total)
  t << ["麹歩合(%)"] + recipe.steps.map{|s| s.koji_ratio * 100}.map{|v| v&.round(2)}
  t << ["汲水歩合(%)"] + recipe.steps.map{|s| s.water_ratio * 100}.map{|v| v&.round(2)}
  t << :separator
  t << ["[累計]"]
  t << ["総米(g)"] + recipe.cumulative_rice_totals
  t << ["白米比率"] + recipe.rice_ratios.map{|v| v&.round(2)}
  t << ["酒母歩合(%)"] + recipe.cumulative_moto_ratios.map{|s| s * 100}.map{|v| v&.round(2)}
  t << ["タンク内容量(ml)"] + recipe.steps.map {|s|
    s.yeasts.map(&:weight).sum + s.lactic_acids.map(&:weight).sum + s.kakes.map(&:steamed).sum + s.kojis.map(&:dekoji).sum + s.waters.map(&:weight).sum + s.alcohols.map(&:weight).sum
  }.then {|a|
    sum = 0.0
    a.map {|x| sum += x}
  }.map{|v| v&.round(2)}
end
puts table
puts


puts "掛米"
table = Terminal::Table.new do |t|
  kakes = recipe.steps.map.with_index {|step,i|
    [i, step.kakes[0]]
  }.select {|a|
    a[1]
  }
  indexes = kakes.map(&:first)
  kakes = kakes.map(&:last)

  t << ["工程", "状態"] + indexes.map{|i| step_names[i]}
  t << :separator
  t << ["", "白米(g)"] + kakes.map(&:weight).map{|v| v&.round(2)}
  t << :separator
  t << ["洗米・浸漬", "浸漬米(g)"] + kakes.map(&:soaked).map{|v| v&.round(2)}
  t << ["", "浸漬米吸水率"] + kakes.map(&:soaking_ratio).map{|v| v&.round(2)}
  t << :separator
  t << ["蒸し", "蒸米(g)"] + kakes.map(&:steamed).map{|v| v&.round(2)}
  t << ["", "蒸米吸水率"] + kakes.map(&:steaming_ratio).map{|v| v&.round(2)}
  t << :separator
  t << ["放冷", "蒸米(g)"] + kakes.map(&:cooled).map{|v| v&.round(2)}
  t << ["", "蒸米吸水率"] + kakes.map(&:cooling_ratio).map{|v| v&.round(2)}
end
puts table
puts

puts "麹"
table = Terminal::Table.new do |t|
  kojis = recipe.steps.map.with_index {|step,i|
    [i, step.kojis[0]]
  }.select {|a|
    a[1]
  }
  indexes = kojis.map(&:first)
  kojis = kojis.map(&:last)

  t << ["工程", "状態"] + indexes.map{|i| step_names[i]}
  t << :separator
  t << ["", "白米(g)"] + kojis.map(&:weight).map{|v| v&.round(2)}
  t << :separator
  t << ["洗米・浸漬", "浸漬米(g)"] + kojis.map(&:soaked).map{|v| v&.round(2)}
  t << ["", "浸漬米吸水率"] + kojis.map(&:soaking_ratio).map{|v| v&.round(2)}
  t << :separator
  t << ["蒸し", "蒸米(g)"] + kojis.map(&:steamed).map{|v| v&.round(2)}
  t << ["", "蒸米吸水率"] + kojis.map(&:steaming_ratio).map{|v| v&.round(2)}
  t << :separator
  t << ["放冷・引き込み", "蒸米(g)"] + kojis.map(&:cooled).map{|v| v&.round(2)}
  t << ["", "蒸米吸水率"] + kojis.map(&:cooling_ratio).map{|v| v&.round(2)}
  t << ["", "種麹(g)"] + kojis.map{|k| k.tanekojis.map(&:weight).sum}.map{|v| v&.round(2)}
  t << :separator
  t << ["出麹", "麹(g)"] + kojis.map(&:dekoji).map{|v| v&.round(2)}
  t << ["", "出麹歩合"] + kojis.map(&:dekoji_ratio).map{|v| v&.round(2)}
end
puts table
puts
