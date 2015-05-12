defmodule Chordpro do
  alias Chordpro.Parser
  alias Chordpro.Formatter

  def to_text(chordpro) do
    chordpro
    |> Parser.parse
    |> Formatter.text
  end
end
