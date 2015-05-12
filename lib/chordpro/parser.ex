defmodule Chordpro.Parser do

  def parse(chordpro_format) do
    chordpro_format
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&elem(&1, 1))
  end

  defp parse_line(line) do
    line
    |> String.strip
    |> categorize
  end

  defp categorize(""),               do: {:empty, nil}
  defp categorize("#" <> _),         do: {:comment, nil}
  defp categorize("{t:" <> title),   do: {:title, cleanup_tagline(title)}
  defp categorize("{st:" <> artist), do: {:artist, cleanup_tagline(artist)}
  defp categorize("{" <> _),         do: {:unknown, nil}
  defp categorize(line),             do: {:line, parse_chords(line)}

  defp cleanup_tagline(line), do: String.rstrip(line, ?})

  defp parse_chords("[" <> line) do
    line
    |> String.split(~r/\[|\]/)
    |> Enum.reject(&(String.length(&1) == 0))
    |> Enum.chunk(2)
    |> split_line
  end
  defp parse_chords(line) do
    parse_chords("[ ]" <> line)
  end

  defp split_line(line) do
    chords =
      line
      |> Enum.map(&space_chords/1)
      |> Enum.join
      |> String.rstrip
    lyrics =
      line
      |> Enum.map(&get_lyrics/1)
      |> Enum.join
    {chords, lyrics}
  end

  defp space_chords([chord, lyric]) do
    String.ljust(chord, String.length(lyric))
  end

  defp get_lyrics([_, lyrics]), do: lyrics
end
