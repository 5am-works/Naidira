require "json"
require "yaml"

module Naidira::Lexicon
  enum WordType
    Noun
    Adjective
    Verb0
    Verb1
    Verb2
    Verb3
    PrefixModifier
    PostfixModifier
    PrefixParticle
    PostfixParticle

    def modifier?
      self == PrefixModifier || self == PostfixModifier
    end

    def verb?
      self == Verb0 || self == Verb1 || self == Verb2 || self == Verb3
    end
  end

  enum WordKind
    Nounlike
    Verblike
    Any
    Sentence
  end

  class Word
    include JSON::Serializable
    include YAML::Serializable

    use_yaml_discriminator "type", {
      noun:             Noun,
      adjective:        Noun,
      verb0:            Verb,
      verb1:            Verb,
      verb2:            Verb,
      verb3:            Verb,
      prefix_modifier:  Modifier,
      postfix_modifier: Modifier,
      prefix_particle:  Particle,
      postfix_particle: Particle,
    }

    property spelling : String
    property type : WordType
    property simple_meaning : String
    property first_appearance : String?

    def initialize(@spelling, @type, @simple_meaning)
    end

    def has_kind?(word_kind : WordKind)
      word_kind == WordKind::Any
    end

    def inspect(io)
      io << spelling << '{' << type << '}'
    end

    def to_s(io)
      io << "#{spelling} (#{type}, word): #{simple_meaning}"
    end

    def is?(word)
      spelling == word
    end
  end

  class Modifier < Word
    include YAML::Serializable
    property modifiable_types : Set(WordKind)
    property attachment_types : Array(WordKind)
    property attachment_notes : Array(String | Nil)

    def initialize(@spelling, @type, @simple_meaning, @modifiable_types, @attachment_types, @attachment_notes)
    end

    def attachment_count
      attachment_types.size
    end

    def prefix?
      type == WordType::PrefixModifier
    end

    def postfix?
      type == WordType::PostfixModifier
    end

    def single_nounlike_attachment?
      attachment_count == 1 || attachment_types[0] == WordKind::Nounlike
    end

    def has_attachments?
      attachment_count > 0
    end

    def modifies_any?
      modifiable_types.first == WordKind::Any
    end

    def modifies_verbs?
      modifiable_types.includes? WordKind::Verblike
    end

    def modifies_nouns?
      modifiable_types.includes? WordKind::Nounlike
    end

    def sentence_attachment?
      attachment_types.first == WordKind::Sentence
    end

    def pp
      "#{spelling} (#{type}, modifier): #{simple_meaning}"
    end
  end

  class Noun < Word
    def has_kind?(word_kind : WordKind)
      word_kind == WordKind::Nounlike
    end

    def pp
      "#{spelling} (#{type}, noun): #{simple_meaning}"
    end
  end

  class Verb < Word
    include YAML::Serializable
    property formatted_meaning : String

    def initialize(@spelling, @type, @simple_meaning, @formatted_meaning)
    end

    def valency
      case type
      when WordType::Verb0
        0
      when WordType::Verb1
        1
      when WordType::Verb2
        2
      else
        raise "Unable to determine valency of #{self}"
      end
    end

    def has_kind?(word_kind : WordKind)
      word_kind == WordKind::Verblike
    end

    def pp
      "#{spelling} (#{type}, verb): #{simple_meaning}"
    end
  end

  class Particle < Word
    def prefix?
      type == WordType::PrefixParticle
    end

    def postfix?
      type == WordType::PostfixParticle
    end
  end
end
