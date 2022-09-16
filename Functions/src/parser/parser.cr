require "./sentence"
require "./lexer"

include Naidira::Lexicon

module Naidira::Parser
  alias LModifier = Naidira::Lexicon::Modifier

  class Parser
    property words : Deque(Constituent)
    @last_read : Predicate | Argument | Nil
    @read_single_sentence = false
    @single_sentence_complete = false

    def initialize(words)
      @words = Deque.new(words)
      @sentences = [] of Sentence
      @sentence = SentenceBuilder.new
      @waiting_modifiers = Deque(Modifier).new
      @waiting_particles = Deque(Particle).new
      @fix_next_argument = nil
    end

    def parse_all : Array(Sentence)
      while !@words.empty?
        next_word = @words.shift
        begin
          parse next_word
        rescue exception
          puts "Error while parsing #{next_word}"
          raise exception
        end
      end
      unless @sentence.empty?
        @sentences << @sentence.build
      end
      @sentences
    end

    def parse_one_sentence(omit : Int? = nil, ri : Bool = false) : Tuple(Sentence, Deque(Constituent))
      @read_single_sentence = true
      while !@words.empty?
        next_word = @words.first
        if parse next_word
          @words.shift
        else
          break
        end
      end
      if @sentences.empty?
        @sentences << @sentence.build
      end
      {@sentences.first, @words}
    end 

    private def parse(predicate : Predicate) : Bool
      unless @waiting_particles.empty?
        @waiting_particles.each do |particle|
          VERB_PARTICLES[particle.spelling]?.try do |p|
            p.call @sentence, predicate
            true
          end || raise "#{particle} cannot be attached to a verb (#{predicate})" 
        end
        @waiting_particles.clear
      end

      unless @waiting_modifiers.empty?
        @waiting_modifiers.each do |modifier|
          if modifier.can_modify? predicate
            predicate.add_modifier modifier
          else
            raise "#{modifier} cannot modify #{predicate}"
          end
        end
        @waiting_modifiers.clear
      end

      if waiting_for_predicate?
        add_to_modifier predicate
      else
        unless @sentence.add_predicate predicate
          @sentences << @sentence.build
          if @read_single_sentence
            return false
          else
            @sentence = SentenceBuilder.new
          end
        end
        @sentence.add_predicate predicate
      end
      @last_read = predicate
      true
    end

    private def parse(argument : Argument)
      unless @waiting_particles.empty?
        @waiting_particles.each do |particle|
          NOUN_PARTICLES[particle.spelling]?.try do |p|
            p.call @sentence, argument
            true
          end || raise "#{particle} needs a noun" 
        end
        @waiting_particles.clear
      end

      unless @waiting_modifiers.empty?
        @waiting_modifiers.each do |modifier|
          if modifier.can_modify? argument
            argument.add_modifier modifier
          else
            raise "#{modifier} cannot modify #{argument}"
          end
        end
        @waiting_modifiers.clear
      end

      if waiting_for_argument?
        add_to_modifier argument
      else
        unless @fix_next_argument.nil?
          next_argument = @fix_next_argument.not_nil!
          unless @sentence.fix_argument next_argument, argument
            @sentences << @sentence.build
            if @read_single_sentence
              return false
            else
              @sentence = SentenceBuilder.new
              @sentence.fix_argument next_argument, argument
            end
          end 
          @fix_next_argument = nil
        else
          unless @sentence.add_argument argument
            @sentences << @sentence.build
            if @read_single_sentence
              return false
            else
              @sentence = SentenceBuilder.new
              @sentence.add_argument argument
            end
          end
        end
      end

      @last_read = argument
      true
    end

    private def parse(modifier : Modifier)
      if modifier.prefix?
        @waiting_modifiers << modifier
      elsif modifier.is? "si"
        subclause = read_subclause(omit: 0)
        modifier.add_attachment subclause
      elsif modifier.is? "ro"
        subclause = read_subclause(ri: true)
        modifier.add_attachment subclause
        argument = @last_read.as? Argument || raise "#{modifier} needs a noun"
        argument.add_modifier modifier
      elsif modifier.modifies_verbs?
        predicate = @last_read.as? Predicate || @sentence.predicate ||
          raise "#{modifier} needs a verb"
        predicate.add_modifier modifier
      else
        argument = @last_read.as? Argument || raise "#{modifier} needs a noun"
        argument.add_modifier modifier
      end

      unless modifier.complete?
        @reading_modifier = modifier
      end
      true
    end

    private def parse(particle : Particle)
      if particle.is? "ne"
        @fix_next_argument = 0
      elsif particle.prefix?
        @waiting_particles << particle
      else
        VERB_PARTICLES[particle.spelling]?.try do |v_particle|
          predicate = @sentence.predicate || raise "#{particle.spelling} needs a verb"
          v_particle.call @sentence, predicate.as(Predicate)
          true
        end || NOUN_PARTICLES[particle.spelling]?.try do |n_particle|
          argument = @last_read.as?(Argument) || raise "#{particle.spelling} needs a noun"
          n_particle.call @sentence, argument.as(Argument)
        end || raise "Unrecognized particle: #{particle.spelling}"
      end
      true
    end

    private def read_subclause(*args, **kwargs)
      subparser = Parser.new @words.to_a
      subclause, remaining_words = subparser.parse_one_sentence(*args, **kwargs)
      @words = remaining_words
      subclause
    end

    private def waiting_for_argument?
      @reading_modifier.try(&.waiting_for? WordKind::Nounlike)
    end

    private def waiting_for_predicate?
      @reading_modifier.try(&.waiting_for? WordKind::Verblike)
    end

    private def add_to_modifier(attachment)
      modifier = @reading_modifier.not_nil!
      modifier.add_attachment attachment
      if modifier.complete?
        @reading_modifier = nil
      end
    end
  end

  def self.parse(sentence : String)
    words = sentence.split
    constituents = Lexer.new(words).run
    self.parse constituents
  end

  def self.parse(constituents : Iterable(Constituent))
    parser = Parser.new constituents
    sentences = parser.parse_all
  end
end
