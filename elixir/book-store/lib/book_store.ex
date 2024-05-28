defmodule BookStore do
  @typedoc "A book is represented by its number in the 5-book series"
  @type book :: 1 | 2 | 3 | 4 | 5

  @doc """
  Calculate lowest price (in cents) for a shopping basket containing books.
  """
  @spec total(basket :: [book]) :: integer
  def total(basket) do
    freq = Enum.frequencies(basket)

    Stream.unfold({%{}, freq}, fn {acc, freq} ->
      group = Enum.filter(freq, fn {_k, v} -> v > 0 end) |> Enum.map(&elem(&1, 0))

      if not Enum.empty?(group) do
        len = Enum.count(group)
        acc = Map.update(acc, len, 1, &(&1 + 1))
        freq = Enum.reduce(group, freq, &Map.update!(&2, &1, fn x -> x - 1 end))
        {acc, {acc, freq}}
      end
    end)
    |> Enum.fetch(-1)
    |> case do
      {:ok, freq} ->
        case {Map.get(freq, 3), Map.get(freq, 5)} do
          {nil, _} ->
            freq

          {_, nil} ->
            freq

          {g3, g5} ->
            d = min(g3, g5)
            Map.merge(freq, %{3 => g3 - d, 5 => g5 - d}) |> Map.update(4, 2 * d, &(&1 + 2 * d))
        end
        |> Enum.reduce(0, fn {group, count}, acc -> acc + price(group) * count end)

      :error ->
        0
    end
  end

  defp price(group) do
    8 * group * (100 - discount(group))
  end

  defp discount(1), do: 0
  defp discount(2), do: 5
  defp discount(3), do: 10
  defp discount(4), do: 20
  defp discount(5), do: 25
end
