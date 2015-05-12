defmodule Chordpro.Cli do
  use Application

  def start(_type, _args), do: {:ok, self}

  def main(args) do
    args
    |> parse_args
    |> process_input
  end

  defp parse_args(args) do
    args
    |> OptionParser.parse
    |> case do
      {[file: f], _, _}    -> {:filename, f}
      {_, _, [{"-f", f}]}  -> {:filename, f}
      {_, [f], _}          -> {:filename, f}
      {[help: true], _, _} -> :help
      {_, _, _}            -> :unknown
    end
  end

  defp process_input({:filename, filename}) do
    filename
    |> read_file
    |> process_file
  end
  defp process_input(:help) do
    """
    usage:
      chordpro file
      chordpro -f file
      chordpro --file file
    """
    |> IO.puts
  end
  defp process_input(:unknown), do: IO.puts "Unknown options, try --help"

  defp process_file({:error, reason}) do
    IO.puts "There was an error opening your file:"
    IO.puts reason
  end
  defp process_file(file) do
    file
    |> Chordpro.Parser.parse
    |> Chordpro.Formatter.text
    |> IO.puts
  end

  defp read_file(filename) do
    filename
    |> Path.expand
    |> File.read
    |> case do
      {:ok, text}       -> text
      {:error, :enoent} -> {:error, "File not found"}
      {:error, :eacces} -> {:error, "Permission denied"}
      {:error, :enomem} -> {:error, "File too large"}
      {:error, _}       -> {:error, "Unknown error"}
    end
  end
end
