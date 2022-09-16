require "spec"
require "../src/naidira"

include Naidira::Parser
include Naidira::Lexicon

SI = DICTIONARY.find("si").as(LModifier)

ATTRIBUTES = {
  :vi => Attribute::Personal
}

def v(verb_entry : String, *modifiers, mood : Mood? = nil, tense : Tense? = nil, negated = false)
  p = Predicate.new(verb(verb_entry))
  p.mood = mood
  p.tense = tense
  modifiers.each do |m|
    p.add_modifier m
  end

  if negated
    p.negate!
  end
  p
end

def v!(verb : String, *args, **kwargs)
  predicate = v verb, *args, **kwargs
  predicate.mood = Mood::Imperative
  predicate
end

def n(noun : String, *adjectives, si : Sentence? = nil, attr : Array(Symbol)? = [] of Symbol,
  m : Array(Modifier) = [] of Modifier)
  entry = DICTIONARY.find(noun).not_nil!.as(Noun)
  a = Argument.new entry
  adjectives.each do |m|
    adjective = DICTIONARY.find(m).not_nil!.as(Noun)
    a.add_adjective adjective
  end

  m.each do |modifier|
    a.add_modifier modifier
  end

  attr.each do |attribute|
    attr = ATTRIBUTES[attribute]
    a.add_attribute attr
  end

  unless si.nil?
    si_modifier = Modifier.new(SI)
    si_modifier.add_attachment si
    a.add_modifier(si_modifier)
  end
  a
end

def m(modifier : String)
  entry = (DICTIONARY.find(modifier) || raise "Modifier not found: #{modifier}").as(LModifier)
  Modifier.new entry
end

def m(modifier : String, *attachments : Attachment)
  modifier = m modifier
  attachments.each do |a|
    modifier.add_attachment(a)
  end
  modifier
end

def s(predicate : Predicate, arguments : Array(Argument?) = Array(Argument?).new(2) { nil })
  Sentence.new(predicate, arguments.map(&.as Argument?))
end

def verb(v : String)
  (DICTIONARY.find(v) || raise "Verb not found: #{v}").as(Verb)
end

def noun(n : String)
  (DICTIONARY.find(n) || raise "Noun not found: #{n}").as(Noun)
end
