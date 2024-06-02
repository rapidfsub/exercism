defmodule ZebraPuzzle do
  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water() do
    get_answer(:beverage, :water)
  end

  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra() do
    get_answer(:pet, :zebra)
  end

  defp get_answer(key, value) do
    do_get_answer()
    |> find_house(key, value)
    |> Map.fetch!(:nationality)
  end

  @properties [
    beverage: ~w[coffee milk orange_juice tea water]a,
    cigarette: ~w[chesterfield kool lucky_strike old_gold parliament]a,
    house: ~w[blue green ivory red yellow]a,
    nationality: ~w[englishman japanese norwegian spaniard ukrainian]a,
    pet: ~w[dog fox horse snail zebra]a
  ]

  @base [Enum.map(0..4, &%{index: &1})]
  defp do_get_answer() do
    @properties
    |> Enum.reduce(@base, fn {key, values}, acc ->
      acc
      |> Stream.flat_map(fn p1 ->
        values
        |> permutation()
        |> Stream.map(fn p2 ->
          Enum.zip_with(p1, p2, &Map.put(&1, key, &2))
        end)
      end)
      |> Stream.reject(&invalid?/1)
    end)
    |> Enum.find(&valid?/1)
  end

  defp permutation(items) do
    do_permutation(items, MapSet.new())
  end

  defp do_permutation(items, did_visit) do
    case Enum.reject(items, &MapSet.member?(did_visit, &1)) do
      [] ->
        [[]]

      xs ->
        Enum.flat_map(xs, fn x ->
          items
          |> do_permutation(MapSet.put(did_visit, x))
          |> Enum.map(&[x | &1])
        end)
    end
  end

  defp valid?(houses) do
    constraints() |> Enum.all?(&valid?(houses, &1))
  end

  defp invalid?(houses) do
    constraints() |> Enum.any?(&invalid?(houses, &1))
  end

  defp constraints() do
    [
      # 1. The Englishman lives in the red house.
      [nationality: :englishman, house: :red],
      # 2. The Spaniard owns the dog.
      [nationality: :spaniard, pet: :dog],
      # 3. Coffee is drunk in the green house.
      [beverage: :coffee, house: :green],
      # 4. The Ukrainian drinks tea.
      [nationality: :ukrainian, beverage: :tea],
      # 5. The green house is immediately to the right of the ivory house.
      [fun: &right?/2, house: :green, house: :ivory],
      # 6. The Old Gold smoker owns snails.
      [cigarette: :old_gold, pet: :snail],
      # 7. Kools are smoked in the yellow house.
      [cigarette: :kool, house: :yellow],
      # 8. Milk is drunk in the middle house.
      [beverage: :milk, index: 2],
      # 9. The Norwegian lives in the first house.
      [nationality: :norwegian, index: 0],
      # 10. The man who smokes Chesterfields lives in the house next to the man with the fox.
      [fun: &next?/2, cigarette: :chesterfield, pet: :fox],
      # 11. Kools are smoked in the house next to the house where the horse is kept.
      [fun: &next?/2, cigarette: :kool, pet: :horse],
      # 12. The Lucky Strike smoker drinks orange juice.
      [cigarette: :lucky_strike, beverage: :orange_juice],
      # 13. The Japanese smokes Parliaments.
      [nationality: :japanese, cigarette: :parliament],
      # 14. The Norwegian lives next to the blue house.
      [fun: &next?/2, nationality: :norwegian, house: :blue]
    ]
  end

  defp valid?(houses, constraint) do
    do_valid?(houses, constraint) == {:ok, true}
  end

  defp invalid?(houses, constraint) do
    do_valid?(houses, constraint) == {:ok, false}
  end

  defp do_valid?(houses, [{_, _}, {_, _}] = constraint) do
    do_valid?(houses, Keyword.put(constraint, :fun, &==/2))
  end

  defp do_valid?(houses, [{:fun, fun}, {k1, v1}, {k2, v2}]) do
    with %{} = home <- find_house(houses, k1, v1),
         %{} = neighbor <- find_house(houses, k2, v2) do
      {:ok, fun.(home, neighbor)}
    else
      _ -> {:error, :unknown}
    end
  end

  defp find_house(houses, key, value) do
    Enum.find(houses, &(Map.get(&1, key) == value))
  end

  defp right?(home, neighbor) do
    home.index == neighbor.index + 1
  end

  defp next?(home, neighbor) do
    right?(home, neighbor) or right?(neighbor, home)
  end
end
