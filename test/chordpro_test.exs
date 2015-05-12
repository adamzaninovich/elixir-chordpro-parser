defmodule ChordproTest do
  use ExUnit.Case
  alias Chordpro.Parser
  alias Chordpro.Formatter

  setup do
    {:ok, crd} = File.read("test/fixtures/twinkle.crd")
    document = [
      title: "Twinkle Twinkle Little Star",
      artist: "Mozart",
      line: {"C       C/E     F      C", "Twinkle twinkle little star"},
      line: {"F     C      G        C", "How I wonder what you are"}
    ]
    {:ok, text} = File.read("test/fixtures/twinkle.txt")
    {:ok, [crd: crd, doc: document, text: String.strip(text)]}
  end

  test "it parses a chordpro string", %{crd: crd, doc: document, text: _} do
    assert Parser.parse(crd) == document
  end

  test "it formats the parsed chordpro doc", %{crd: _, doc: document, text: text} do
    assert Formatter.text(document) == text
  end

  test "it parses and formats chordpro", %{crd: crd, doc: _, text: text} do
    assert Chordpro.to_text(crd) == text
  end

  test "it works when lines don't start with chords" do
    {:ok, crd} = File.read("test/fixtures/adventure.crd")
    {:ok, txt} = File.read("test/fixtures/adventure.txt")
    assert Chordpro.to_text(crd) == String.strip(txt)
  end

  test "it works with no title" do
    assert Chordpro.to_text("{st:Name}") ==
      "Unknown Title\nName\n"
  end

  test "it works when lines contain unknown commands" do
    assert Chordpro.to_text("{c:Name}\n{soc}\n[C]Stuff [D]Other\n{eoc}") ==
      "Unknown Title\nUnknown Artist\n\nC     D\nStuff Other"
  end
end
