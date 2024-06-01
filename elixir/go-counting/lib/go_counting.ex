defmodule GoCounting do
  @type position :: {integer, integer}
  @type owner :: %{owner: atom, territory: [position]}
  @type territories :: %{white: [position], black: [position], none: [position]}

  @doc """
  Return the owner and territory around a position
  """
  @spec territory(board :: String.t(), position :: position) ::
          {:ok, owner} | {:error, String.t()}
  def territory(board, pos) do
    matrix = get_matrix(board)

    if Map.has_key?(matrix, pos) do
      matrix
      |> get_territories()
      |> Enum.find(fn {_owner, ps} -> pos in ps end)
      |> case do
        nil -> {:ok, %{owner: :none, territory: []}}
        {owner, ps} -> {:ok, %{owner: owner, territory: Enum.sort(ps)}}
      end
    else
      {:error, "Invalid coordinate"}
    end
  end

  @doc """
  Return all white, black and neutral territories
  """
  @spec territories(board :: String.t()) :: territories
  def territories(board) do
    acc = %{black: [], white: [], none: []}

    for {owner, ps} <- get_matrix(board) |> get_territories(), p <- ps, reduce: acc do
      acc -> Map.update!(acc, owner, &[p | &1])
    end
    |> Map.new(fn {k, v} -> {k, Enum.sort(v)} end)
  end

  defp get_matrix(board) do
    [r1 | _] = rows = String.split(board, "\n", trim: true) |> Enum.map(&String.graphemes/1)
    acc = %{rows: length(rows), cols: length(r1)}

    for {row, r} <- Enum.with_index(rows), {cell, c} <- Enum.with_index(row), into: acc do
      {{c, r}, cell}
    end
  end

  defp get_territories(matrix) do
    for c <- 0..(matrix.cols - 1), r <- 0..(matrix.rows - 1) do
      {c, r}
    end
    |> Enum.with_index()
    |> Enum.reduce(%{matrix: matrix, territories: Map.new()}, fn {p, i}, acc ->
      do_get_territories(acc, p, i)
    end)
    |> Map.fetch!(:territories)
    |> Enum.map(fn {_index, ps} -> {get_owner(matrix, ps), ps} end)
  end

  @directions Enum.flat_map([-1, 1], &[{&1, 0}, {0, &1}])
  defp do_get_territories(%{matrix: m, territories: ts} = token, p, index) do
    case Map.get(m, p) do
      "_" ->
        token = %{matrix: Map.put(m, p, nil), territories: Map.update(ts, index, [p], &[p | &1])}

        for dp <- @directions, reduce: token do
          acc -> do_get_territories(acc, add(p, dp), index)
        end

      _ ->
        token
    end
  end

  defp add({lx, ly}, {rx, ry}) do
    {lx + rx, ly + ry}
  end

  defp get_owner(matrix, ps) do
    for p <- ps, dp <- @directions do
      Map.get(matrix, add(p, dp))
    end
    |> Enum.frequencies()
    |> case do
      %{"B" => _, "W" => _} -> :none
      %{"B" => _} -> :black
      %{"W" => _} -> :white
      %{} -> :none
    end
  end
end
