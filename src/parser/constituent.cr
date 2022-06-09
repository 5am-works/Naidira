require "../word"
require "./particles"

include Naidira::Lexicon
alias LModifier = Naidira::Lexicon::Modifier

module Naidira::Parser
  alias Constituent = Predicate | Argument | Modifier

  class Predicate
    property base_word : Verb
    property mood : Mood?
    property modifiers : Set(Modifier)

    def initialize(@base_word, @mood = nil, @modifiers = Set(Modifier).new)
    end

    def add_modifier(modifier : Modifier)
      modifiers << modifier
    end

    def inspect(io)
      io << base_word.spelling
      case mood
      when Mood::Imperative
        io << '!'
      end

      unless modifiers.empty?
        io << '<' << modifiers << '>'
      end
    end

    def imperative?
      mood == Mood::Imperative
    end

    def ==(other : Predicate)
      base_word == other.base_word && mood == other.mood
    end
  end

  class Argument
    property base_word : Set(Noun)

    def initialize(base_word)
      @base_word = Set.new [base_word]
    end

    def add_adjective(adj : Noun)
      base_word << adj
    end

    def inspect(io)
      base_word.inspect(io)
    end

    def ==(other : Argument)
      base_word == other.base_word
    end
  end

  alias Attachment = Argument | Predicate

  class Modifier
    property base_word : LModifier
    property attachments : Array(Attachment)

    def initialize(@base_word, @attachments = [] of Attachment)
    end

    def add_attachment(attachment)
      @attachments << attachment
    end

    def waiting_for?(attachment_type)
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

    def can_modify?(_p : Predicate)
      base_word.modifiable_types.includes? WordKind::Verblike
    end

    def single_nounlike_attachment?
      base_word.single_nounlike_attachment?
    end

    def ==(other : Modifier)
      base_word == other.base_word && attachments == other.attachments
    end
  end
end
