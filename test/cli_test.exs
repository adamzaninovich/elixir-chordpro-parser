defmodule CliTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test :start do
    {status, _pid} = Chordpro.Cli.start(nil, nil)
    assert status == :ok
  end

  test "it outputs an error when given a bad filename" do
    assert cli_output("blah") == """
    There was an error opening your file:
    File not found
    """
  end

  test "it parses the file when using --file" do
    assert cli_output(["--file", "test/fixtures/twinkle.crd"]) == twinkle
  end

  test "it parses the file when using -f" do
    assert cli_output(["-f", "test/fixtures/twinkle.crd"]) == twinkle
  end

  test "it parses the file when using just filename" do
    assert cli_output("test/fixtures/twinkle.crd") == twinkle
  end

  test "it outputs usage when given --help" do
    assert cli_output("--help") == """
    usage:
      chordpro file
      chordpro -f file
      chordpro --file file

    """
  end

  test "it outputs error message when given unknown option" do
    assert cli_output("--blah") == "Unknown options, try --help\n"
  end

  defp cli_output("" <> input), do: cli_output([input])
  defp cli_output(input) do
    capture_io fn ->
      Chordpro.Cli.main(input)
    end
  end

  defp twinkle do
    """
    Twinkle Twinkle Little Star\nMozart

    C       C/E     F      C
    Twinkle twinkle little star
    F     C      G        C
    How I wonder what you are
    """
  end

end
