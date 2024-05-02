defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) when start_bottle > 0 do
    start_bottle..1//-1
    |> Enum.take(take_down)
    |> Enum.map(&paragraph/1)
    |> Enum.join("\n\n")
  end

  defp paragraph(count) when count > 0 do
    line = sentence(count) |> String.capitalize()

    """
    #{line},
    #{line},
    And if one green bottle should accidentally fall,
    There'll be #{sentence(count - 1)}.\
    """
  end

  defp sentence(count) do
    "#{in_english(count)} green #{bottle(count)} hanging on the wall"
  end

  defp bottle(1), do: "bottle"
  defp bottle(_count), do: "bottles"

  defp in_english(0), do: "no"
  defp in_english(1), do: "one"
  defp in_english(2), do: "two"
  defp in_english(3), do: "three"
  defp in_english(4), do: "four"
  defp in_english(5), do: "five"
  defp in_english(6), do: "six"
  defp in_english(7), do: "seven"
  defp in_english(8), do: "eight"
  defp in_english(9), do: "nine"
  defp in_english(10), do: "ten"
end
