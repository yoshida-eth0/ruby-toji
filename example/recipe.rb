$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'toji'
require_relative 'example_core'
require 'terminal-table'

recipe = Example::Recipe::TEMPLATES[:sokujo_nada].scale(900).round(2)
step_names = ["酛", "添", "仲", "留", "四段"].slice(0, recipe.steps.length)

table = Terminal::Table.new do |t|
  t << [""] + step_names
  t << :separator
  t << ["[原料]"]
  t << ["酵母(g or 本)"] + recipe.steps.map(&:yeast)
  t << ["乳酸(ml)"] + recipe.steps.map(&:lactic_acid)
  t << ["掛米(g)"] + recipe.steps.map(&:kake)
  t << ["麹米(g)"] + recipe.steps.map(&:koji)
  t << ["汲水(ml)"] + recipe.steps.map(&:water)
  t << ["醸造アルコール(ml)"] + recipe.steps.map(&:alcohol)
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
    kake = Toji::Ingredient::Kake::Expected.create(s.kake)
    koji = Toji::Ingredient::Koji::Expected.create(s.koji)
    s.yeast.to_f + s.lactic_acid.to_f + kake.steamed.to_f + koji.dekoji.to_f + s.water.to_f + s.alcohol.to_f
  }.then {|a|
    sum = 0.0
    a.map {|x| sum += x}
  }.map{|v| v&.round(2)}
end
puts table
puts


puts "掛米"
table = Terminal::Table.new do |t|
  kakes = recipe.steps.map {|step|
    Toji::Ingredient::Kake::Expected.create(step.kake)
  }

  t << ["工程", "原料"] + step_names
  t << :separator
  t << ["洗米・浸漬", "白米(g)"] + kakes.map(&:weight).map{|v| v&.round(2)}
  t << ["", "吸水増加量(ml)"] + kakes.map(&:soaking_water).map{|v| v&.round(2)}
  t << :separator
  t << ["水切り", "浸漬米(g)"] + kakes.map(&:soaked).map{|v| v&.round(2)}
  t << ["", "汲水(ml)"] + kakes.map(&:steaming_water).map{|v| v&.round(2)}
  t << :separator
  t << ["蒸し", "蒸米(g)"] + kakes.map(&:steamed).map{|v| v&.round(2)}
end
puts table
puts

puts "麹"
table = Terminal::Table.new do |t|
  kojis = recipe.steps.map {|step|
    Toji::Ingredient::Koji::Expected.create(step.koji)
  }

  t << ["工程", "原料"] + step_names
  t << :separator
  t << ["洗米・浸漬", "白米(g)"] + kojis.map(&:weight).map{|v| v&.round(2)}
  t << ["", "吸水増加量(ml)"] + kojis.map(&:soaking_water).map{|v| v&.round(2)}
  t << :separator
  t << ["水切り", "浸漬米(g)"] + kojis.map(&:soaked).map{|v| v&.round(2)}
  t << ["", "汲水(ml)"] + kojis.map(&:steaming_water).map{|v| v&.round(2)}
  t << :separator
  t << ["蒸し", "蒸米(g)"] + kojis.map(&:steamed).map{|v| v&.round(2)}
  t << :separator
  t << ["放冷・引込み", "蒸米(g)"] + kojis.map(&:cooled).map{|v| v&.round(2)}
  t << ["", "種麹(g)"] + kojis.map(&:tanekoji).map{|v| v&.round(2)}
  t << :separator
  t << ["製麹", "麹(g)"] + kojis.map(&:dekoji).map{|v| v&.round(2)}
end
puts table
puts
