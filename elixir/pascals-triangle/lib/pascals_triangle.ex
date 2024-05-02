defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) when num > 0 do
    do_rows(num) |> Enum.reverse()
  end

  defp do_rows(num) when num > 1 do
    [prev | _] = triangle = do_rows(num - 1)
    curr = Enum.chunk_every([0 | prev], 2, 1) |> Enum.map(&Enum.sum/1)
    [curr | triangle]
  end

  defp do_rows(1) do
    [[1]]
  end
end
