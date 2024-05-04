defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance(~c"AAGTCATA", ~c"TAGCGATC")
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) do
    hamming_dist(strand1, strand2, 0)
  end

  defp hamming_dist([], [], result), do: {:ok, result}
  defp hamming_dist([n | lhs], [n | rhs], result), do: hamming_dist(lhs, rhs, result)
  defp hamming_dist([_l | lhs], [_r | rhs], result), do: hamming_dist(lhs, rhs, result + 1)
  defp hamming_dist(_lhs, _rhs, _result), do: {:error, "strands must be of equal length"}
end
