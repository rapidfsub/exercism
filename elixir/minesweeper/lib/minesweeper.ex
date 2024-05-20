defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]
  def annotate([r1 | _] = board) do
    rows = length(board)
    cols = String.length(r1)

    matrix =
      for {line, r} <- Enum.with_index(board, 1),
          {cell, c} <- String.graphemes(line) |> Enum.with_index(1),
          into: %{} do
        {{r, c}, cell}
      end

    for r <- 1..rows//1 do
      for c <- 1..cols//1 do
        cell = Map.get(matrix, {r, c})

        with " " <- cell, cnt when cnt > 0 <- count(matrix, r, c) do
          to_string(cnt)
        else
          _ -> cell
        end
      end
      |> to_string()
    end
  end

  def annotate([]) do
    []
  end

  defp count(matrix, r, c) do
    [{0, 1}, {1, 1}, {1, 0}, {1, -1}]
    |> Enum.flat_map(fn {dr, dc} -> [{r + dr, c + dc}, {r - dr, c - dc}] end)
    |> Enum.count(&(Map.get(matrix, &1) == "*"))
  end
end
