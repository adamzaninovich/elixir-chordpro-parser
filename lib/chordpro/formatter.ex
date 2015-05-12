defmodule Chordpro.Formatter do
  def text([]), do: ""
  def text([{:title, title}, {:artist, artist} | rest]) do
    [title, artist, "" | format_lines(rest)]
    |> Enum.join("\n")
  end
  def text([{:title, title} | rest]) do
    text([{:title, title}, {:artist, "Unknown Artist"} | rest])
  end
  def text([{:artist, artist} | rest]) do
    text([{:title, "Unknown Title"}, {:artist, artist} | rest])
  end
  def text([rest]) do
    text([{:title, "Unknown Title"}, {:artist, "Unknown Artist"} | rest])
  end

  defp format_lines({:line, line}), do: [format_line({:line, line})]
  defp format_lines(lines), do: Enum.map(lines, &format_line/1)

  defp format_line({:line, {chords, lyrics}}) do
    Enum.join([chords, lyrics], "\n")
  end
end
