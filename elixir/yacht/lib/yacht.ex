defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(category, dice) when category in ~w[ones twos threes fours fives sixes]a do
    die = from_category_to_integer(category)
    die * Enum.count(dice, &(&1 == die))
  end

  def score(:full_house, dice) do
    dice
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort()
    |> case do
      [2, 3] -> Enum.sum(dice)
      _ -> 0
    end
  end

  def score(:four_of_a_kind, dice) do
    case Enum.frequencies(dice) |> Enum.find(&(elem(&1, 1) >= 4)) do
      {die, _count} -> 4 * die
      nil -> 0
    end
  end

  def score(:little_straight, dice) do
    case Enum.sort(dice) do
      [1, 2, 3, 4, 5] -> 30
      _ -> 0
    end
  end

  def score(:big_straight, dice) do
    case Enum.sort(dice) do
      [2, 3, 4, 5, 6] -> 30
      _ -> 0
    end
  end

  def score(:choice, dice), do: Enum.sum(dice)
  def score(:yacht, [d, d, d, d, d]), do: 50
  def score(:yacht, _dice), do: 0

  defp from_category_to_integer(:ones), do: 1
  defp from_category_to_integer(:twos), do: 2
  defp from_category_to_integer(:threes), do: 3
  defp from_category_to_integer(:fours), do: 4
  defp from_category_to_integer(:fives), do: 5
  defp from_category_to_integer(:sixes), do: 6
end
