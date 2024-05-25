defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: exclude, size: size, sum: sum}) do
    for nums <- cages(size), Enum.sum(nums) == sum, Enum.all?(nums, &(&1 not in exclude)) do
      nums
    end
  end

  defp cages(n) do
    do_cages(n) |> Enum.map(&Enum.reverse/1)
  end

  defp do_cages(1) do
    Enum.map(1..9, &List.wrap/1)
  end

  defp do_cages(size) do
    for [x | _] = nums <- do_cages(size - 1), y <- (x + 1)..9//1 do
      [y | nums]
    end
  end
end
