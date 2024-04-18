defmodule StateOfTicTacToe do
  @lines Enum.flat_map(0..2, fn i -> [[{i, 0}, {i, 1}, {i, 2}], [{0, i}, {1, i}, {2, i}]] end) ++
           [[{0, 0}, {1, 1}, {2, 2}], [{0, 2}, {1, 1}, {2, 0}]]

  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    board =
      for {row, i} <- String.split(board, "\n") |> Enum.with_index(),
          {cell, j} <- String.graphemes(row) |> Enum.with_index(),
          into: %{} do
        {{i, j}, cell}
      end

    %{"X" => x_win, "O" => o_win} =
      Enum.reduce(@lines, %{"X" => 0, "O" => 0}, fn points, acc ->
        case Enum.map(points, &Map.fetch!(board, &1)) do
          [x, x, x] -> Map.update(acc, x, 1, &(&1 + 1))
          _ -> acc
        end
      end)

    tally = Enum.frequencies_by(board, &elem(&1, 1))
    o_count = Map.get(tally, "O", 0)
    x_count = Map.get(tally, "X", 0)

    cond do
      x_count < o_count ->
        {:error, "Wrong turn order: O started"}

      x_count == o_count ->
        cond do
          x_win > 0 -> {:error, "Impossible board: game should have ended after the game was won"}
          o_win > 0 -> {:ok, :win}
          x_count + o_count < 9 -> {:ok, :ongoing}
          true -> {:ok, :draw}
        end

      x_count == o_count + 1 ->
        cond do
          o_win > 0 -> {:error, "Impossible board: game should have ended after the game was won"}
          x_win > 0 -> {:ok, :win}
          x_count + o_count < 9 -> {:ok, :ongoing}
          true -> {:ok, :draw}
        end

      true ->
        {:error, "Wrong turn order: X went twice"}
    end
  end
end
