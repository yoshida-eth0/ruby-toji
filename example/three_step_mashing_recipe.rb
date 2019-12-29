require 'toji'
require 'terminal-table'

recipe = Toji::Recipe::ThreeStepMashing.new(Toji::Ingredient::Yeast::RedStar, 2000)

table = Terminal::Table.new do |t|
  t << [""] + recipe.class::STEP_NAMES
  t << :separator
  t << ["[原料]"]
  t << ["酵母(g)", recipe.yeast.yeast]
  t << ["酵母吸水", recipe.yeast.water]
  t << ["乳酸(ml)"]
  t << ["掛米(g)"] + recipe.steps.map(&:rice).map(&:raw)
  t << ["麹米(g)"] + recipe.steps.map(&:koji).map(&:raw)
  t << ["汲水(ml)"] + recipe.steps.map(&:water)
  t << :separator
  t << ["[合計]"]
  t << ["総米(g)"] + recipe.steps.map(&:rice_total)
  t << ["麹歩合(%)"] + recipe.steps.map{|s| s.koji_rate * 100}
  t << ["汲水歩合(%)"] + recipe.steps.map{|s| s.water_rate * 100}
  t << :separator
  t << ["[累計]"]
  t << ["総米(g)"] + recipe.cumulative_rice_totals
  t << ["白米比率"] + recipe.rice_rates
  t << ["酒母歩合(%)"] + recipe.cumulative_shubo_rates.map{|s| s * 100}
  t << ["タンク内容量(ml)"] + recipe.cumulative_weight_totals
end
puts table
puts


puts "掛米"
table = Terminal::Table.new do |t|
  t << ["工程", "原料"] + recipe.class::STEP_NAMES
  t << :separator
  t << ["洗米・浸漬", "白米(g)"] + recipe.steps.map(&:rice).map(&:raw)
  t << ["", "吸水増加量(ml)"] + recipe.steps.map(&:rice).map(&:soaking_water)
  t << :separator
  t << ["水切り", "浸漬米(g)"] + recipe.steps.map(&:rice).map(&:soaked)
  t << ["", "汲水(ml)"] + recipe.steps.map(&:rice).map(&:steaming_water)
  t << :separator
  t << ["蒸し", "蒸米(g)"] + recipe.steps.map(&:rice).map(&:steamed)
end
puts table
puts

puts "麹"
table = Terminal::Table.new do |t|
  t << ["工程", "原料"] + recipe.class::STEP_NAMES
  t << :separator
  t << ["洗米・浸漬", "白米(g)"] + recipe.steps.map(&:koji).map(&:raw)
  t << ["", "吸水増加量(ml)"] + recipe.steps.map(&:koji).map(&:soaking_water)
  t << :separator
  t << ["水切り", "浸漬米(g)"] + recipe.steps.map(&:koji).map(&:soaked)
  t << ["", "汲水(ml)"] + recipe.steps.map(&:koji).map(&:steaming_water)
  t << :separator
  t << ["蒸し", "蒸米(g)"] + recipe.steps.map(&:koji).map(&:steamed)
  t << :separator
  t << ["放冷・引込み", "蒸米(g)"] + recipe.steps.map(&:koji).map(&:cooled)
  t << ["", "種麹(g)"] + recipe.steps.map(&:koji).map(&:tanekoji)
  t << :separator
  t << ["製麹", "麹(g)"] + recipe.steps.map(&:koji).map(&:dekoji)
end
puts table
puts
