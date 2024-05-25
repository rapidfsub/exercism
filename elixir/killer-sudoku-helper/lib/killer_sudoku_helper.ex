defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(cage) do
    ns = Enum.filter(9..1//-1, &(&1 not in cage.exclude))
    permutation([], [], 0, cage.size, ns) |> Enum.filter(&(Enum.sum(&1) == cage.sum))
  end

  defp permutation(acc, xs, size, size, _ns), do: [xs | acc]
  defp permutation(acc, _xs, _len, _size, []), do: acc

  defp permutation(acc, xs, len, size, [n | ns]) do
    permutation(acc, xs, len, size, ns) |> permutation([n | xs], len + 1, size, ns)
  end
end
