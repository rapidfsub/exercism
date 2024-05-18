defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    lines = String.split(input, "\n")
    len = Enum.map(lines, &String.length/1) |> Enum.max()

    lines
    |> Enum.map(fn line ->
      String.pad_trailing(line, len, "\0") |> String.graphemes()
    end)
    |> Enum.zip_with(&to_string/1)
    |> Enum.map_join("\n", fn line ->
      String.trim_trailing(line, "\0") |> String.replace("\0", " ")
    end)
  end
end
