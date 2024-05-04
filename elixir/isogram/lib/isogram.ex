defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.replace(~r/[^\p{L}]/u, "")
    |> String.downcase()
    |> String.graphemes()
    |> Enum.frequencies()
    |> Enum.all?(&(elem(&1, 1) < 2))
  end
end
