defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(cage) do
    ns = Enum.filter(9..1//-1, &(&1 not in cage.exclude))
    permutation([], [], cage.size, ns) |> Enum.filter(&(Enum.sum(&1) == cage.sum))
  end

  defp permutation(acc, xs, 0, _ns), do: [xs | acc]
  defp permutation(acc, _xs, _size, []), do: acc

  defp permutation(acc, xs, size, [n | ns]) do
    permutation(acc, xs, size, ns) |> permutation([n | xs], size - 1, ns)
  end
end
