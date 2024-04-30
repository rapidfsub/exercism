defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    Enum.filter(candidates, &do_match(&1, base))
  end

  defp do_match(l, r) do
    case {String.downcase(l), String.downcase(r)} do
      {word, word} -> false
      {lhs, rhs} -> letters(lhs) == letters(rhs)
    end
  end

  defp letters(word) do
    String.graphemes(word) |> Enum.sort()
  end
end
