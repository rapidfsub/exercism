defmodule WordSearch do
  defmodule Location do
    defstruct [:from, :to]

    @type t :: %Location{
            from: %{row: integer, column: integer},
            to: %{row: integer, column: integer}
          }

    def new({r1, c1}, {r2, c2}) do
      %__MODULE__{from: %{row: r1, column: c1}, to: %{row: r2, column: c2}}
    end
  end

  @doc """
  Find the start and end positions of words in a grid of letters.
  Row and column positions are 1 indexed.
  """
  @spec search(grid :: String.t(), words :: [String.t()]) :: %{String.t() => nil | Location.t()}
  def search(grid, words) do
    lines = [l1 | _] = String.split(grid, "\n")
    rows = Enum.count(lines)
    cols = String.length(l1)
    matrix = parse(lines)

    for word <- words, reduce: %{} do
      acc ->
        location = String.graphemes(word) |> get_location(matrix, rows, cols)
        Map.put(acc, word, location)
    end
  end

  defp parse(lines) do
    for {line, r} <- Enum.with_index(lines, 1),
        {cell, c} <- String.graphemes(line) |> Enum.with_index(1),
        into: %{} do
      {{r, c}, cell}
    end
  end

  defp get_location(letters, matrix, rows, cols) do
    Enum.find_value(1..rows, fn r ->
      Enum.find_value(1..cols, &do_get_location(letters, matrix, {r, &1}))
    end)
  end

  @directions for dr <- -1..1//1, dc <- -1..1//1, {dr, dc} != {0, 0}, do: {dr, dc}
  defp do_get_location(letters, matrix, from) do
    case Enum.find_value(@directions, &get_to(letters, matrix, from, &1)) do
      nil -> nil
      to -> Location.new(from, to)
    end
  end

  defp get_to(letters, matrix, {r, c} = position, {dr, dc} = direction) do
    case {Map.get(matrix, position), letters} do
      {nil, _letters} -> nil
      {letter, [letter]} -> position
      {letter, [letter | rest]} -> get_to(rest, matrix, {r + dr, c + dc}, direction)
      {_letter, _letters} -> nil
    end
  end
end
