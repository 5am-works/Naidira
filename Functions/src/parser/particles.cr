require "./constituent"

include Naidira::Lexicon

module Naidira::Parser
  enum Mood
    Imperative
    Optative
    Potential
  end

  enum Tense
    Complete
  end

  enum Attribute
    Personal
  end

  VERB_PARTICLES = {
    "ta" => ->(s : SentenceBuilder, p : Predicate) do
      p.mood = Mood::Imperative
      s.imperative!
    end,
    "ti" => ->(s : SentenceBuilder, p : Predicate) do
      p.mood = Mood::Imperative
      s.imperative!
    end,
    "rita" => ->(s : SentenceBuilder, p : Predicate) do
      p.tense = Tense::Complete
    end,
    "li" => ->(s : SentenceBuilder, p : Predicate) do
      p.mood = Mood::Optative
    end,
    "mine" => ->(s : SentenceBuilder, p : Predicate) do
      p.mood = Mood::Potential
    end,
    "mui" => ->(s : SentenceBuilder, p : Predicate) do
      p.negate!
    end
  }

  NOUN_PARTICLES = {
    "vi" => ->(s : SentenceBuilder, a : Argument) do
      a.add_attribute Attribute::Personal
    end
  }
end
