require "./parser/parser"
require "./dictionary"

include Naidira::Parser

print "Enter a sentence: "
sentence = gets.not_nil!.chomp

begin
  words = sentence.split
  constituents = Lexer.new(words).run
  puts "Constituents: #{constituents}"
  result = Naidira::Parser.parse constituents

  puts "Parsed: #{result}"
rescue exception
  puts "Parse error: #{exception}"
end