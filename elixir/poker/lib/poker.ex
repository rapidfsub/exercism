defmodule Poker do
  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands) do
    [{_, result} | _] = Enum.group_by(hands, &hand_score/1) |> Enum.sort_by(&elem(&1, 0), :desc)
    result
  end

  defp hand_score(hand) do
    hand =
      hand
      |> Enum.map(fn card ->
        [_, rank, suit] = Regex.run(~r/(10|[JQKA2-9])([CDHS])/, card)
        {rank_value(rank), suit}
      end)
      |> Enum.sort(:desc)

    [r1 | _] =
      modified_ranks =
      case Enum.map(hand, &elem(&1, 0)) do
        [14, 5, 4, 3, 2] -> [5, 4, 3, 2, 1]
        ranks -> ranks
      end

    frequencies = Enum.frequencies(modified_ranks) |> Enum.sort_by(fn {k, v} -> {v, k} end, :desc)
    is_straight = modified_ranks == [r1, r1 - 1, r1 - 2, r1 - 3, r1 - 4]
    is_flush = Enum.dedup_by(hand, &elem(&1, 1)) |> length() == 1
    tie_breaker = Enum.map(frequencies, &elem(&1, 0))
    {category_score(frequencies, is_straight, is_flush), tie_breaker}
  end

  defp rank_value("J"), do: 11
  defp rank_value("Q"), do: 12
  defp rank_value("K"), do: 13
  defp rank_value("A"), do: 14
  defp rank_value(rank), do: String.to_integer(rank)

  defp category_score(frequencies, is_straight, is_flush)
  defp category_score([{_, 1}, {_, 1}, {_, 1}, {_, 1}, {_, 1}], true, true), do: 8
  defp category_score([{_, 4}, {_, 1}], false, false), do: 7
  defp category_score([{_, 3}, {_, 2}], false, false), do: 6
  defp category_score([{_, 1}, {_, 1}, {_, 1}, {_, 1}, {_, 1}], false, true), do: 5
  defp category_score([{_, 1}, {_, 1}, {_, 1}, {_, 1}, {_, 1}], true, false), do: 4
  defp category_score([{_, 3}, {_, 1}, {_, 1}], false, false), do: 3
  defp category_score([{_, 2}, {_, 2}, {_, 1}], false, false), do: 2
  defp category_score([{_, 2}, {_, 1}, {_, 1}, {_, 1}], false, false), do: 1
  defp category_score([{_, 1}, {_, 1}, {_, 1}, {_, 1}, {_, 1}], false, false), do: 0
end
