require 'csv'

puts "Welcome to the christmas list"
# gift is a hash now -> {name: "bike", bought: true}

gift_list = []
# gift_list = [{name: "bike", bought: false}, {name: "puppy", bought: true}]
# gift_list is array of hashes
filepath = 'save.csv'

# Load from the CSV into an array
CSV.foreach(filepath, col_sep: ',', quote_char: '"', headers: :first_row) do |row|
  gift_list << { name: row["name"], bought: row["bought"] }
end

def display_list(list)
  list.each_with_index do |gift, index|
    status = gift[:bought] ? "[X]" : "[ ]"
    puts "#{index + 1} - #{status} #{gift[:name]} :))"
  end
end

answer = ""
while answer != "quit"
  # 2. Add the mark to the options
  puts "What do you want to do [list|add|mark|delete|quit]?"
  answer = gets.chomp
  case answer
  when "list"
    # 3. Adjust how we display gifts
      # 1 - [X] - gift 1
      # 2 - [ ] - some new bike
      # 3 - [X] - puppy
      if gift_list.empty?
        puts "The list is empty now. Add some items"
      else
        display_list(gift_list)
      end

      # gift_list.empty? ? (puts "The list is empty now. Add some items") : display_list(gift_list)
  when "add"
    puts "What would you like to add"
    gift = gets.chomp.capitalize
    # 4. create a hash {} from the gift
    # {name: "something", bought: false}
    new_gift = {
      name: gift,
      bought: false
    }
    gift_list << new_gift
    puts " #{gift} was added to your list"
  when "mark"
    # 6. Ask which item was bought (number)?
    puts "Which one did you buy (number)?"
    display_list(gift_list)
    # 7. Save the user answer (substruct 1 to get the actual index)
    user_input_index = gets.chomp.to_i - 1
    # 8. Update the bought value of the gift (find it in the array by the index)
    gift_list[user_input_index][:bought] = true
    puts "#{gift_list[user_input_index][:name]} was marked as bought"

  when "delete"
    puts "Which gift do you want to delete (number) ?"
    display_list(gift_list)
    gift_index = gets.chomp.to_i - 1
    gift_list.delete_at(gift_index)
  when "quit"
    # save everything they have in their gift list into our CSV
    CSV.open(filepath, 'wb', col_sep: ',', force_quotes: true, quote_char: '"') do |csv|
      csv << ["name", "bought"]
      gift_list.each do |gift|
        csv << [gift[:name], gift[:bought]]
      end
    end

    puts "exiting program"
  else
    puts "Choose one of the valid actions [list|add|delete|quit]"
  end
end

puts "Goodbye"
