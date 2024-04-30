defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence = String.downcase(sentence) |> String.replace(~r/[^\p{L}\p{N}']+/u, " ")

    Regex.scan(~r/\b[\p{L}\p{N}']+\b/u, sentence)
    |> List.flatten()
    |> Enum.frequencies()
  end
end
