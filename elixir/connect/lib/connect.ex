defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for([r1 | _] = board) do
    rows = length(board)
    cols = String.length(r1)
    matrix = get_matrix(board)
    Enum.find_value([:black, :white], :none, &get_winner(matrix, &1, rows, cols))
  end

  defp get_matrix(board) do
    for {line, r} <- Enum.with_index(board, 1),
        {tile, c} <- String.graphemes(line) |> Enum.with_index(1),
        into: %{} do
      {{r, c}, get_stone(tile)}
    end
  end

  defp get_stone("O"), do: :white
  defp get_stone("X"), do: :black
  defp get_stone("."), do: nil

  defp get_winner(matrix, stone, rows, cols) do
    Enum.find_value(1..rows//1, false, fn r ->
      do_get_winner(matrix, stone, {r, 1}, MapSet.new(), &match?({_, ^cols}, &1))
    end) ||
      Enum.find_value(1..cols//1, false, fn c ->
        do_get_winner(matrix, stone, {1, c}, MapSet.new(), &match?({^rows, _}, &1))
      end)
  end

  defp do_get_winner(matrix, stone, {row, col} = point, did_visit, fun) do
    cond do
      MapSet.member?(did_visit, point) or Map.get(matrix, point) != stone ->
        nil

      fun.(point) ->
        stone

      true ->
        did_visit = MapSet.put(did_visit, point)

        [{1, 0}, {1, -1}, {0, 1}]
        |> Enum.flat_map(fn {dr, dc} -> [{row + dr, col + dc}, {row - dr, col - dc}] end)
        |> Enum.find_value(&do_get_winner(matrix, stone, &1, did_visit, fun))
    end
  end
end
