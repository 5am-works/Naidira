require "./dictionary"

include Naidira::Lexicon

dictionary = Dictionary.load_yaml

loop do
  begin
    puts "Enter an option:
1. Search for words
2. Add a word
3. Backfill first appearances
0. Quit
"

    input = gets.try &.to_i
    case input
    when 1
      search dictionary
    when 2
      add dictionary
    when 3
      backfill dictionary
    when 0
      dictionary.save_yaml
      break
    else
      puts "Invalid selection"
    end
  rescue exception
    puts exception
  end
end

def search(dictionary)
  print "Enter a word: "
  input = gets.try &.chomp
  result = dictionary.find(input.not_nil!)
  if result.nil?
    puts "Word not found"
  else
    puts result
  end
end

def add(dictionary)
  print "Enter the word: "
  spelling = gets.try &.chomp
  if spelling.nil?
    puts "Did not receive input"
    return
  end

  if existing = dictionary.find(spelling)
    puts "Word already exists: #{existing}"
    return
  end

  type = prompt_type "Select the word type:"

  print "Enter the meaning: "
  simple_meaning = gets.not_nil!.chomp

  if type.verb?
    print "Enter the formatted meaning: "
    formatted_meaning = gets.not_nil!.chomp
    new_word = Verb.new(spelling, type, simple_meaning, formatted_meaning)
  elsif type.modifier?
    print "Enter the number of modifiable types: "
    count = gets.not_nil!.to_i
    modifiable_types = Array.new(count) do |i|
      prompt_kind "Select a type (#{i}/#{count}):"
    end

    print "Enter the number of attachments: "
    count = gets.not_nil!.to_i
    attachment_types = Array.new(count) do |i|
      prompt_kind "Select the type for attachment (#{i + 1}/#{count}):"
    end

    new_word = Modifier.new(spelling, type, simple_meaning, modifiable_types.to_set,
      attachment_types, Array(String | Nil).new(count) { nil })
  elsif type.noun?
    new_word = Noun.new(spelling, type, simple_meaning)
  else
    new_word = Word.new(spelling, type, simple_meaning)
  end

  puts new_word
  loop do
    print "Is this okay? (y/n) "
    input = gets.not_nil!.chomp
    if input == "y"
      dictionary.add new_word
      break
    elsif input == "n"
      break
    end
  end
end

def backfill(dictionary)
  existing_entries = dictionary.sources
  dictionary.each do |word|
    puts "Enter the source for #{word}"
    existing_entries.each_with_index do |source, index|
      puts "#{index}. #{source}"
    end
    input = gets.not_nil!.chomp
    existing = input.to_i?
    selected = if existing.nil?
      existing_entries << input
      input
    elsif input.empty?
      nil
    else
      existing_entries[existing]
    end
    word.first_appearance = selected
  end
end

def prompt_type(prompt : String)
  puts prompt
  WordType.values.each_with_index do |type, index|
    print "#{index}.#{type} "
  end
  puts
  WordType.new(gets.try(&.to_i).not_nil!)
end

def prompt_kind(prompt : String)
  puts prompt
  WordKind.values.each_with_index do |type, index|
    print "#{index}.#{type} "
  end
  puts
  WordKind.new(gets.not_nil!.to_i)
end
