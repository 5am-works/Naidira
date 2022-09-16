require "./spec_helper"

include Naidira

describe Parser do
  it "can parse the first verse of Silika's Sleepsong" do
    text = <<-TEXT
    levi ti bome
    leimi ti mara
    romi ti nori
    mailomi gemi rita
    TEXT
    expected = [
      s(v!("bome"), [nil, n("levi")]),
      s(v!("mara"), [nil, n("leimi")]),
      s(v!("nori"), [nil, n("romi")]),
      s(v("gemi", tense: Tense::Complete), [n("mailomi"), nil]),
    ]
    Parser.parse(text).should eq(expected)
  end

  it "can parse the second verse of Silika's Sleepsong" do
    text = <<-TEXT
    vele ki tuiri
    ne vele ki meina
    ne vele polini rita leimina
    TEXT
    expected = [
      s(v("ki"), [n("vele"), n("tuiri")]),
      s(v("ki"), [n("vele"), n("meina")]),
      s(v("polini", tense: Tense::Complete), [n("vele"), n("leimina")])
    ]
    Parser.parse(text).should eq(expected)
  end

  it "can parse the third verse of Silika's Sleepsong" do
    text = <<-TEXT
    ne belime rumi revi li seliti vi
    kena boli vi senai li
    lunata bera li vele be norima
    ro vele ki mine rila so ri
    TEXT
    expected = [
      s(v("revi", mood: Mood::Optative), [n("belime", "rumi"), n("seliti", attr: [:vi])]),
      s(v("senai", mood: Mood::Optative), [n("kena", "boli", attr: [:vi]), nil]),
      s(v("bera", m("be", n("norima", m: [m("ro", s(v("ki", m("so", n("ri")), mood: Mood::Potential),
        [n("vele"), n("rila")]))])), mood: Mood::Optative), [n("lunata"), n("vele")]),
    ]
    Parser.parse(text).should eq(expected)
  end

  it "can parse the fourth verse of Silika's Sleepsong" do
    text = <<-TEXT
    voto ta mivila la rote
    musi ta fide ve kumei
    pelora ta luna beti
    de senui lumei
    TEXT
    expected = [
      s(v!("voto"), [nil, n("rote", m: [m("la", n("mivila"))])]),
      s(v!("musi"), [nil, n("fide", m: [m("ve", n("kumei"))])]),
      s(v!("pelora"), [nil, n("luna", "beti", m: [m("de", n("senui", "lumei"))])])
    ]
    Parser.parse(text).should eq(expected)
  end

  it "can parse the fifth verse of Silika's Sleepsong" do
    text = <<-TEXT
    mui leiri ta naro
    mui lura ta leimi lumite vi 
    mui leiri ta naro
    mui lura ta suina lumite vi
    TEXT
    expected = [
      s(v!("leiri", m("naro"), negated: true), [nil, nil]),
      s(v!("lura", negated: true), [nil, n("leimi", "lumite", attr: [:vi])]),
      s(v!("leiri", m("naro"), negated: true), [nil, nil]),
      s(v!("lura", negated: true), [nil, n("suina", "lumite", attr: [:vi])])
    ]
    Parser.parse(text).should eq(expected)
  end

  it "can parse the sixth verse of Silika's Sleepsong" do
    text = <<-TEXT
    vele ki sevi
    ne vele ki luvi
    ne vele kola rita duna vi be tuto
    pena ta mani so meili
    TEXT
    expected = [
      s(v("ki"), [n("vele"), n("sevi")]),
      s(v("ki"), [n("vele"), n("luvi")]),
      s(v("kola", m("be", n("tuto")), tense: Tense::Complete), [n("vele"), n("duna", attr: [:vi])]),
      s(v!("pena", m("mani"), m("so", n("meili"))), [nil, nil])
    ]
    Parser.parse(text).should eq(expected)
  end

  it "can parse the full text of Silika's Sleepsong" do
    text = <<-TEXT
    levi ti bome
    leimi ti mara
    romi ti nori
    mailomi gemi rita

    vele ki tuiri
    ne vele ki meina
    ne vele polini rita leimina

    ne belime rumi revi li seliti vi
    kena boli vi senai li
    lunata bera li vele be norima
    ro vele ki mine rila so ri

    voto ta mivila la rote
    musi ta fide ve kumei
    pelora ta luna beti
    de senui lumei

    mui leiri ta naro
    mui lura ta leimi lumite vi
    mui leiri ta naro
    mui lura ta suina lumite vi

    vele ki sevi
    ne vele ki luvi
    ne vele kola rita duna vi be tuto
    pena ta mani so meili
    TEXT
    expected = [
      s(v!("bome"), [nil, n("levi")]),
      s(v!("mara"), [nil, n("leimi")]),
      s(v!("nori"), [nil, n("romi")]),
      s(v("gemi", tense: Tense::Complete), [n("mailomi"), nil]),
      s(v("ki"), [n("vele"), n("tuiri")]),
      s(v("ki"), [n("vele"), n("meina")]),
      s(v("polini", tense: Tense::Complete), [n("vele"), n("leimina")]),
      s(v("revi", mood: Mood::Optative), [n("belime", "rumi"), n("seliti", attr: [:vi])]),
      s(v("senai", mood: Mood::Optative), [n("kena", "boli", attr: [:vi]), nil]),
      s(v("bera", m("be", n("norima", m: [m("ro", s(v("ki", m("so", n("ri")), mood: Mood::Potential),
        [n("vele"), n("rila")]))])), mood: Mood::Optative), [n("lunata"), n("vele")]),
      s(v!("voto"), [nil, n("rote", m: [m("la", n("mivila"))])]),
      s(v!("musi"), [nil, n("fide", m: [m("ve", n("kumei"))])]),
      s(v!("pelora"), [nil, n("luna", "beti", m: [m("de", n("senui", "lumei"))])]),
      s(v!("leiri", m("naro"), negated: true), [nil, nil]),
      s(v!("lura", negated: true), [nil, n("leimi", "lumite", attr: [:vi])]),
      s(v!("leiri", m("naro"), negated: true), [nil, nil]),
      s(v!("lura", negated: true), [nil, n("suina", "lumite", attr: [:vi])]),
      s(v("ki"), [n("vele"), n("sevi")]),
      s(v("ki"), [n("vele"), n("luvi")]),
      s(v("kola", m("be", n("tuto")), tense: Tense::Complete), [n("vele"), n("duna", attr: [:vi])]),
      s(v!("pena", m("mani"), m("so", n("meili"))), [nil, nil])
    ] of Sentence
    Parser.parse(text).should eq(expected)
  end
end