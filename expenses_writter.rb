require 'rexml/document'
require 'date'

begin
  current_path = File.dirname(__FILE__)
  file_name = current_path + "/expense.xml"

  file = File.new(file_name, 'r:UTF-8')
  doc = REXML::Document.new file
  file.close

rescue Errno::ENOENT
  abort "READING DOCUMENT NOT FOUND"
rescue REXML::ParseException
  abort "ERROR IN STRUCTURE READING DOCUMENT"
end


puts "What did you buy?"
expense_text = STDIN.gets.chomp
puts "How much did you spend money?"
expense_money = STDIN.gets.chomp
puts "When was this? [2017.08.24]"
expense_date = STDIN.gets.chomp

expense_date.empty? ? expense_date = Date.today :
    expense_date = Date.parse(expense_date)


expenses = doc.elements.find("expenses").first # get root element
expense = expenses.add_element 'expense', { # add attributes
    "date" => expense_date,
    "amount" => expense_money,
    "value" => expense_text
}

begin
  file = File.new(file_name, 'w:UTF-8')
  doc.write(file, 2)
  file.close
rescue Errno::ENOENT
  abort "WRITING DOCUMENT NOT FOUND"
end

# Decorate input information about save
i = 0
loop do
  print ">"
  sleep 0.4
  i += 1
  break if i >= 5
end
puts "\nDOCUMENT IS SAVE!"