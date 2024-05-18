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

    reversed =
      lines
      |> Enum.map(&(String.pad_trailing(&1, len, " ") |> String.graphemes()))
      |> Enum.zip_with(&to_string/1)
      |> Enum.reverse()

    {reversed, 0}
    |> Stream.unfold(fn
      {[], _} ->
        nil

      {[head | tail], prev_len} ->
        text = String.trim_trailing(head)
        curr_len = String.length(text) |> max(prev_len)
        {String.pad_trailing(text, curr_len, " "), {tail, curr_len}}
    end)
    |> Enum.reverse()
    |> Enum.join("\n")
  end
end
