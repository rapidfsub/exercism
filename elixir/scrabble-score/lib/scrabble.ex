defmodule Scrabble do
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    word
    |> String.upcase()
    |> String.graphemes()
    |> Enum.map(&do_score/1)
    |> Enum.sum()
  end

  defp do_score(letter) when letter in ~w[A E I O U L N R S T], do: 1
  defp do_score(letter) when letter in ~w[D G], do: 2
  defp do_score(letter) when letter in ~w[B C M P], do: 3
  defp do_score(letter) when letter in ~w[F H V W Y], do: 4
  defp do_score(letter) when letter in ~w[K], do: 5
  defp do_score(letter) when letter in ~w[J X], do: 8
  defp do_score(letter) when letter in ~w[Q Z], do: 10
  defp do_score(_letter), do: 0
end
