require "../word"
require "./particles"

include Naidira::Lexicon
alias LModifier = Naidira::Lexicon::Modifier

module Naidira::Parser
  alias Constituent = Predicate | Argument | Modifier | Particle

  class Predicate
    property base_word : Verb
    property mood : Mood?
    property tense : Tense?
    property modifiers : Set(Modifier)
    property negated : Bool

    def initialize(@base_word, @mood = nil, @modifiers = Set(Modifier).new)
      @negated = false
    end

    def add_modifier(modifier : Modifier)
      modifiers << modifier
    end

    def negate!
      raise "#{self} is already negated" if @negated
      @negated = true
    end

    def valency
      base_word.valency
    end

    def inspect(io)
      io << base_word.spelling
      case mood
      when Mood::Imperative
        io << '!'
      when Mood::Optative
        io << '^'
      end

      unless modifiers.empty?
        io << '<' << modifiers << '>'
      end
    end

    def to_s(io)
      inspect io
    end

    def imperative?
      mood == Mood::Imperative
    end

    def ==(other : Predicate)
      base_word == other.base_word && mood == other.mood && modifiers == other.modifiers
    end
  end

  class Argument
    property base_word : Set(Noun)
    property modifiers = Set(Modifier).new
    property attributes = Set(Attribute).new

    def initialize(base_word)
      @base_word = Set.new [base_word]
    end

    def add_adjective(adj : Noun)
      base_word << adj
    end

    def add_modifier(modifier : Modifier)
      modifiers << modifier
    end

    def add_attribute(attr : Attribute)
      attributes << attr
    end

    def inspect(io)
      base_word.inspect(io)
      unless attributes.empty?
        attributes.each do |attribute|
          case attribute
          when Attribute::Personal
            io << '%'
          end
        end
      end
      unless modifiers.empty?
        io << "<"
        io << modifiers
        io << ">"
      end
    end

    def to_s(io)
      inspect io
    end

    def ==(other : Argument)
      base_word == other.base_word && modifiers == other.modifiers &&
        attributes == other.attributes
    end
  end

  class Reference
    property argument : Argument

    def initialize(@argument)
    end
  end

  alias Attachment = Argument | Predicate | Sentence

  class Modifier
    property base_word : LModifier
    property attachments : Array(Attachment)

    def initialize(@base_word, @attachments = [] of Attachment)
    end

    def add_attachment(attachment)
      @attachments << attachment
    end

    def waiting_for?(attachment_type : WordKind)
      if complete?
        false
      else
        next_attachment = base_word.attachment_types[attachments.size]
        next_attachment == attachment_type || next_attachment == WordKind::Any
      end
    end

    def complete?
      attachments.size == base_word.attachment_count
    end

    def inspect(io)
      base_word.inspect(io)
      io << attachments
    end

    def to_s(io)
      inspect io
    end

    def prefix?
      base_word.prefix?
    end

    def modifies_verbs?
      base_word.modifies_verbs? || base_word.modifies_any?
    end

    def can_modify?(_p : Predicate)
      modifies_verbs?
    end

    def can_modify?(_a : Argument)
      base_word.modifies_nouns? || base_word.modifies_any?
    end

    def single_nounlike_attachment?
      base_word.single_nounlike_attachment?
    end

    def sentence_attachment?
      base_word.sentence_attachment?
    end

    def is?(modifier : String)
      base_word.spelling == modifier
    end

    def ==(other : Modifier)
      base_word == other.base_word && attachments == other.attachments
    end
  end
end
