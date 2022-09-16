require "./spec_helper"

include Naidira

describe Lexer do
  it "can lexicalize arguments" do
    input = ["peli", "romi"]
    expected = [n("peli", "romi")]
    Parser.lexicalize(input).should eq(expected)
  end

  it "can lexicalize particles" do
    input = ["moresa", "si", "pena"]
    expected = [n("moresa"), m("si"), v("pena")]
    Parser.lexicalize(input).should eq(expected)
  end
end
