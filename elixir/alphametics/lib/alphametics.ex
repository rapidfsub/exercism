defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

    iex> Alphametics.solve("I + BB == ILL")
    %{?I => 1, ?B => 9, ?L => 0}

    iex> Alphametics.solve("A == B")
    nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    words =
      puzzle
      |> String.split(~r/(\+|==)/)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&to_charlist/1)

    {output, operands} = List.pop_at(words, -1)
    letters = List.flatten(words) |> Enum.uniq() |> Enum.sort()
    non_zeros = MapSet.new(words, &hd/1)

    do_solve(%{}, letters, MapSet.new(), non_zeros, fn result ->
      operands
      |> Enum.map(&to_integer(&1, result))
      |> Enum.sum() == to_integer(output, result)
    end)
  end

  defp do_solve(result, [], _did_visit, _non_zeros, fun) do
    if fun.(result) do
      result
    end
  end

  defp do_solve(result, [head | tail], did_visit, non_zeros, fun) do
    if MapSet.member?(non_zeros, head) do
      1..9
    else
      0..9
    end
    |> Enum.filter(&(not MapSet.member?(did_visit, &1)))
    |> Enum.find_value(fn n ->
      result
      |> Map.put(head, n)
      |> do_solve(tail, MapSet.put(did_visit, n), non_zeros, fun)
    end)
  end

  defp to_integer(text, result) do
    for digit <- Enum.map(text, &Map.fetch!(result, &1)), reduce: 0 do
      acc -> acc * 10 + digit
    end
  end
end
