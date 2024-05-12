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
    [{_, result} | _] = Enum.group_by(hands, &get_score/1) |> Enum.sort_by(&elem(&1, 0), :desc)
    result
  end

  defp get_score(hand) do
    hand
    |> Enum.map(&String.split_at(&1, -1))
    |> Enum.map(fn {rank, suit} -> {rank_to_integer(rank), suit} end)
    |> Enum.sort()
    |> do_get_score()
  end

  defguardp is_straight(r1, r2, r3, r4, r5)
            when {r1, r2, r3, r4, r5} == {r1, r1 + 1, r2 + 1, r3 + 1, r4 + 1}

  # straight_flush
  defp do_get_score([{r1, s}, {r2, s}, {r3, s}, {r4, s}, {r5, s}])
       when is_straight(r1, r2, r3, r4, r5),
       do: {8, r5}

  defp do_get_score([{2, s}, {3, s}, {4, s}, {5, s}, {14, s}]), do: {8, 5}

  # four_of_a_kind
  defp do_get_score([{r2, _}, {r2, _}, {r2, _}, {r2, _}, {r1, _}]), do: {7, {r2, r1}}
  defp do_get_score([{r1, _}, {r2, _}, {r2, _}, {r2, _}, {r2, _}]), do: {7, {r2, r1}}

  # full_house
  defp do_get_score([{r1, _}, {r1, _}, {r1, _}, {r2, _}, {r2, _}]), do: {6, {r1, r2}}
  defp do_get_score([{r1, _}, {r1, _}, {r2, _}, {r2, _}, {r2, _}]), do: {6, {r2, r1}}

  # flush
  defp do_get_score([{r1, s}, {r2, s}, {r3, s}, {r4, s}, {r5, s}]), do: {5, {r5, r4, r3, r2, r1}}

  # straight
  defp do_get_score([{r1, _s1}, {r2, _s2}, {r3, _s3}, {r4, _s4}, {r5, _s5}])
       when is_straight(r1, r2, r3, r4, r5),
       do: {4, r5}

  defp do_get_score([{2, _s1}, {3, _s2}, {4, _s3}, {5, _s4}, {14, _s5}]), do: {4, 5}

  # three_of_a_kind
  defp do_get_score([{r3, _}, {r3, _}, {r3, _}, {r1, _}, {r2, _}]), do: {3, {r3, r2, r1}}
  defp do_get_score([{r1, _}, {r3, _}, {r3, _}, {r3, _}, {r2, _}]), do: {3, {r3, r2, r1}}
  defp do_get_score([{r1, _}, {r2, _}, {r3, _}, {r3, _}, {r3, _}]), do: {3, {r3, r2, r1}}

  # two_pair
  defp do_get_score([{r2, _}, {r2, _}, {r3, _}, {r3, _}, {r1, _}]), do: {2, {r3, r2, r1}}
  defp do_get_score([{r2, _}, {r2, _}, {r1, _}, {r3, _}, {r3, _}]), do: {2, {r3, r2, r1}}
  defp do_get_score([{r1, _}, {r2, _}, {r2, _}, {r3, _}, {r3, _}]), do: {2, {r3, r2, r1}}

  # one_pair
  defp do_get_score([{r4, _}, {r4, _}, {r1, _}, {r2, _}, {r3, _}]), do: {1, {r4, r3, r2, r1}}
  defp do_get_score([{r1, _}, {r4, _}, {r4, _}, {r2, _}, {r3, _}]), do: {1, {r4, r3, r2, r1}}
  defp do_get_score([{r1, _}, {r2, _}, {r4, _}, {r4, _}, {r3, _}]), do: {1, {r4, r3, r2, r1}}
  defp do_get_score([{r1, _}, {r2, _}, {r3, _}, {r4, _}, {r4, _}]), do: {1, {r4, r3, r2, r1}}

  # high_card
  defp do_get_score([{r1, _}, {r2, _}, {r3, _}, {r4, _}, {r5, _}]), do: {0, {r5, r4, r3, r2, r1}}

  defp rank_to_integer("J"), do: 11
  defp rank_to_integer("Q"), do: 12
  defp rank_to_integer("K"), do: 13
  defp rank_to_integer("A"), do: 14
  defp rank_to_integer(rank), do: String.to_integer(rank)
end
