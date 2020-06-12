require 'toji'
require 'terminal-table'

recipe = Toji::Recipe::TEMPLATES[:sokujo_nada].scale(900)
step_names = recipe.steps.map(&:name)

table = Terminal::Table.new do |t|
  t << [""] + step_names
  t << :separator
  t << ["[原料]"]
  t << ["酵母(g)", recipe.yeast.yeast&.round(2)]
  t << ["酵母吸水", recipe.yeast.water&.round(2)]
  t << ["乳酸(ml)"] + recipe.steps.map(&:lactic_acid).map{|v| v&.round(6)}
  t << ["掛米(g)"] + recipe.steps.map(&:rice).map(&:raw).map{|v| v&.round(2)}
  t << ["麹米(g)"] + recipe.steps.map(&:koji).map(&:raw).map{|v| v&.round(2)}
  t << ["汲水(ml)"] + recipe.steps.map(&:water).map{|v| v&.round(2)}
  t << ["醸造アルコール(ml)"] + recipe.steps.map(&:alcohol).map{|v| v&.round(2)}
  t << :separator
  t << ["[合計]"]
  t << ["総米(g)"] + recipe.steps.map(&:rice_total).map{|v| v&.round(2)}
  t << ["麹歩合(%)"] + recipe.steps.map{|s| s.koji_rate * 100}.map{|v| v&.round(2)}
  t << ["汲水歩合(%)"] + recipe.steps.map{|s| s.water_rate * 100}.map{|v| v&.round(2)}
  t << :separator
  t << ["[累計]"]
  t << ["総米(g)"] + recipe.cumulative_rice_totals.map{|v| v&.round(2)}
  t << ["白米比率"] + recipe.rice_rates.map{|v| v&.round(2)}
  t << ["酒母歩合(%)"] + recipe.cumulative_shubo_rates.map{|s| s * 100}.map{|v| v&.round(2)}
  t << ["タンク内容量(ml)"] + recipe.cumulative_weight_totals.map{|v| v&.round(2)}
end
puts table
puts


puts "掛米"
table = Terminal::Table.new do |t|
  t << ["工程", "原料"] + step_names
  t << :separator
  t << ["洗米・浸漬", "白米(g)"] + recipe.steps.map(&:rice).map(&:raw).map{|v| v&.round(2)}
  t << ["", "吸水増加量(ml)"] + recipe.steps.map(&:rice).map(&:soaking_water).map{|v| v&.round(2)}
  t << :separator
  t << ["水切り", "浸漬米(g)"] + recipe.steps.map(&:rice).map(&:soaked).map{|v| v&.round(2)}
  t << ["", "汲水(ml)"] + recipe.steps.map(&:rice).map(&:steaming_water).map{|v| v&.round(2)}
  t << :separator
  t << ["蒸し", "蒸米(g)"] + recipe.steps.map(&:rice).map(&:steamed).map{|v| v&.round(2)}
end
puts table
puts

puts "麹"
table = Terminal::Table.new do |t|
  t << ["工程", "原料"] + step_names
  t << :separator
  t << ["洗米・浸漬", "白米(g)"] + recipe.steps.map(&:koji).map(&:raw).map{|v| v&.round(2)}
  t << ["", "吸水増加量(ml)"] + recipe.steps.map(&:koji).map(&:soaking_water).map{|v| v&.round(2)}
  t << :separator
  t << ["水切り", "浸漬米(g)"] + recipe.steps.map(&:koji).map(&:soaked).map{|v| v&.round(2)}
  t << ["", "汲水(ml)"] + recipe.steps.map(&:koji).map(&:steaming_water).map{|v| v&.round(2)}
  t << :separator
  t << ["蒸し", "蒸米(g)"] + recipe.steps.map(&:koji).map(&:steamed).map{|v| v&.round(2)}
  t << :separator
  t << ["放冷・引込み", "蒸米(g)"] + recipe.steps.map(&:koji).map(&:cooled).map{|v| v&.round(2)}
  t << ["", "種麹(g)"] + recipe.steps.map(&:koji).map(&:tanekoji).map{|v| v&.round(2)}
  t << :separator
  t << ["製麹", "麹(g)"] + recipe.steps.map(&:koji).map(&:dekoji).map{|v| v&.round(2)}
end
puts table
puts
