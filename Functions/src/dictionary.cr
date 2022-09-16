require "baked_file_system"
require "yaml"
require "./word"

module Naidira::Lexicon
  class Dictionary
    extend BakedFileSystem
    include YAML::Serializable
    @@LEXICON_FILE = "#{__DIR__}/data/lexicon.yaml"

    property words = Hash(String, Word).new

    bake_folder "./data"

    def self.load_yaml
      input_file = if File.exists? @@LEXICON_FILE
                     File.new(@@LEXICON_FILE)
                   else
                     Dictionary.get("lexicon.yaml")
                   end

      Dictionary.from_yaml(input_file)
    end

    def find(word : String)
      words[word]?
    end

    def search(query : String)
      words.each_value.select do |word|
        word.spelling.includes?(query) || word.simple_meaning.includes?(query)
      end
    end

    def sources
      words.values.map do |word|
        word.first_appearance
      end.reject(&.nil?).uniq.to_a
    end

    def each
      words.values.each do |word|
        yield word
      end
    end

    def alphabetical
      words.values.sort do |a, b|
        a.spelling <=> b.spelling
      end
    end

    def add(word)
      words[word.spelling] = word
    end

    def save_yaml
      File.open(@@LEXICON_FILE, "w") do |file|
        to_yaml(file)
      end
    end
  end
end
