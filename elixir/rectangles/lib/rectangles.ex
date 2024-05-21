defmodule Rectangles do
  @doc """
  Count the number of ASCII rectangles.
  """
  @spec count(input :: String.t()) :: integer
  def count(input) do
    m = parse(input)
    points = Enum.filter(m, &match?({_, "+"}, &1)) |> Enum.map(&elem(&1, 0))

    for p1 = {r1, c1} <- points,
        p2 = {^r1, c2} when c1 != c2 <- points,
        p3 = {r2, ^c1} when r1 != r2 <- points,
        p4 = {^r2, ^c2} <- points,
        Enum.all?([{p1, p2}, {p1, p3}, {p2, p4}, {p3, p4}], &connected?(m, &1)),
        into: MapSet.new() do
      Enum.sort([p1, p2, p3, p4])
    end
    |> Enum.count()
  end

  defp parse(input) do
    for {line, r} <- String.split(input, "\n") |> Enum.with_index(),
        {cell, c} <- String.graphemes(line) |> Enum.with_index(),
        into: %{} do
      {{r, c}, cell}
    end
  end

  defp connected?(m, {{r, c1}, {r, c2}}), do: Enum.map(c1..c2, &{r, &1}) |> all_in?(m, ~w[+ -])
  defp connected?(m, {{r1, c}, {r2, c}}), do: Enum.map(r1..r2, &{&1, c}) |> all_in?(m, ~w[+ |])
  defp connected?(_m, {_p1, _p2}), do: false

  defp all_in?(items, map, candids) do
    Enum.all?(items, &(Map.fetch!(map, &1) in candids))
  end
end
