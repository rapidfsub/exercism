defmodule StateOfTicTacToe do
  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    board = board |> String.split("\n") |> Enum.map(&String.graphemes/1)

    matrix =
      for {row, i} <- Enum.with_index(board), {x, j} <- Enum.with_index(row), into: %{} do
        {{i, j}, x}
      end

    wins =
      0..2
      |> Enum.flat_map(fn i ->
        [
          [{i, 0}, {i, 1}, {i, 2}],
          [{0, i}, {1, i}, {2, i}]
        ]
      end)
      |> List.insert_at(0, [{0, 0}, {1, 1}, {2, 2}])
      |> List.insert_at(0, [{0, 2}, {1, 1}, {2, 0}])
      |> Enum.reduce(%{"X" => 0, "O" => 0}, fn points, acc ->
        [value | _] = values = points |> Enum.map(&Map.fetch!(matrix, &1))

        if value in ["X", "O"] and values |> Enum.all?(&(&1 == value)) do
          acc |> Map.update!(value, &(&1 + 1))
        else
          acc
        end
      end)

    o_win = wins |> Map.get("O", 0)
    x_win = wins |> Map.get("X", 0)

    tally = board |> List.flatten() |> Enum.frequencies()
    o_count = tally |> Map.get("O", 0)
    x_count = tally |> Map.get("X", 0)

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
