require "./constituent"

module Naidira::Parser
  class Lexer
    @words : Array(String)
    @constituents : Deque(Constituent)
    @reading_modifier : Modifier?
    @last_read_argument : Argument?
    @waiting_particles : Deque(Particle)

    def initialize(@words : Array(String))
      @constituents = Deque(Constituent).new
      @waiting_particles = Deque(Particle).new
    end

    def run
      @words.each do |word|
        lemma = DICTIONARY.find(word) || raise "Word not found: #{word}"
        process lemma
      end
      
      unless @reading_modifier.nil?
        @constituents << @reading_modifier.not_nil!
      end
      @constituents.to_a
    end

    private def process(noun : Noun)
      unless @last_read_argument.nil?
        @last_read_argument.not_nil!.add_adjective noun
        return
      end

      argument = Argument.new noun

      
      @constituents << argument
      @last_read_argument = argument
    end

    private def process(verb : Verb)
      predicate = Predicate.new verb

      @constituents << predicate
      @last_read_argument = nil
    end

    private def process(lmodifier : LModifier)
      modifier = Modifier.new lmodifier
      if lmodifier.prefix? && lmodifier.single_nounlike_attachment?
        last_argument = @constituents.pop? || raise "#{lmodifier.spelling} needs an attachment"
        unless last_argument.is_a? Argument
          raise "#{lmodifier.spelling} needs an argument, but found #{last_argument}"
        end

        modifier.add_attachment last_argument
        @constituents << modifier
      else
        @constituents << modifier
      end
      @last_read_argument = nil
    end

    private def process(particle : Particle)
      @constituents << particle
      @last_read_argument = nil
    end

    private def process(word)
      raise "TODO: Process #{word.spelling}"
    end
  end

  def self.lexicalize(words)
    Lexer.new(words).run
  end
end
