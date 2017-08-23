require 'rexml/document'
require 'date'

current_path = File.dirname(__FILE__)
file_name = current_path + '/expense.xml'

abort "FILE NOT FOUND" unless File.exists?(file_name)

file = File.new(file_name)
doc = REXML::Document.new(file)

amount_by_day = {}

# В этом хэше, по результату его работы, мы получаем
# Объект даты (ключ) и сумму (значение), потраченную в этот день,
# Даже если трат было несколько.

sum = 0
com = ""

doc.elements.each("expenses/expense") do |item|
  loss_sum = item.attributes["amount"].to_i
  loss_date = Date.parse(item.attributes["date"])
  loss_comment = item.attributes["value"]

  amount_by_day[loss_date] ||= []

  if amount_by_day[loss_date][0] != nil
    sum += loss_sum
    com += " + " + loss_comment
  else
    sum = loss_sum
    com = loss_comment
  end

  amount_by_day[loss_date][0] = sum
  amount_by_day[loss_date][1] = com

end

file.close

amount_by_moth = {}
current_mounth = amount_by_day.keys.sort[0].strftime("%B %Y") # June 2015

amount_by_day.keys.sort.each do |key|
  amount_by_moth[key.strftime("%B %Y")] ||= 0
  amount_by_moth[key.strftime("%B %Y")] += amount_by_day[key][0] # June 2015 => 4990
end

puts "======================"
puts "=== [#{current_mounth}] ==="
puts "      #{amount_by_moth[current_mounth]} RUB."
puts "======================\n\n"

amount_by_day.keys.sort.each do |key|
  if key.strftime("%B %Y") != current_mounth
    current_mounth = key.strftime("%B %Y")
    puts "======================"
    puts "=== [#{current_mounth}] ==="
    puts "      #{amount_by_moth[current_mounth]} RUB."
    puts "======================\n\n"
  end

  puts "[#{key.strftime("%d %B")}]. #{amount_by_day[key][0]} RUB. >>>\n \"#{amount_by_day[key][1]}\" \n\n"
end