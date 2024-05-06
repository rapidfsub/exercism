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
  def score(category, dice) do
    Enum.sort(dice) |> do_score(category)
  end

  defp do_score(dice, category) when category in ~w[ones twos threes fours fives sixes]a do
    die = from_category_to_integer(category)
    die * Enum.count(dice, &(&1 == die))
  end

  defp do_score([a, a, a, b, b] = dice, :full_house) when a != b, do: Enum.sum(dice)
  defp do_score([a, a, b, b, b] = dice, :full_house) when a != b, do: Enum.sum(dice)
  defp do_score([a, a, a, a, _], :four_of_a_kind), do: 4 * a
  defp do_score([_, a, a, a, a], :four_of_a_kind), do: 4 * a
  defp do_score([1, 2, 3, 4, 5], :little_straight), do: 30
  defp do_score([2, 3, 4, 5, 6], :big_straight), do: 30
  defp do_score([a, a, a, a, a], :yacht), do: 50
  defp do_score([_, _, _, _, _] = dice, :choice), do: Enum.sum(dice)
  defp do_score([_, _, _, _, _], _category), do: 0

  defp from_category_to_integer(:ones), do: 1
  defp from_category_to_integer(:twos), do: 2
  defp from_category_to_integer(:threes), do: 3
  defp from_category_to_integer(:fours), do: 4
  defp from_category_to_integer(:fives), do: 5
  defp from_category_to_integer(:sixes), do: 6
end
