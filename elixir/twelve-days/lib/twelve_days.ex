defmodule TwelveDays do
  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    "On the #{in_english(number)} day of Christmas my true love gave to me: #{gifts(number)} in a Pear Tree."
  end

  defp in_english(1), do: "first"
  defp in_english(2), do: "second"
  defp in_english(3), do: "third"
  defp in_english(4), do: "fourth"
  defp in_english(5), do: "fifth"
  defp in_english(6), do: "sixth"
  defp in_english(7), do: "seventh"
  defp in_english(8), do: "eighth"
  defp in_english(9), do: "ninth"
  defp in_english(10), do: "tenth"
  defp in_english(11), do: "eleventh"
  defp in_english(12), do: "twelfth"

  defp gifts(number) when number > 2, do: gift(number) <> ", " <> gifts(number - 1)
  defp gifts(2), do: gift(2) <> ", and " <> gifts(1)
  defp gifts(1), do: gift(1)

  defp gift(1), do: "a Partridge"
  defp gift(2), do: "two Turtle Doves"
  defp gift(3), do: "three French Hens"
  defp gift(4), do: "four Calling Birds"
  defp gift(5), do: "five Gold Rings"
  defp gift(6), do: "six Geese-a-Laying"
  defp gift(7), do: "seven Swans-a-Swimming"
  defp gift(8), do: "eight Maids-a-Milking"
  defp gift(9), do: "nine Ladies Dancing"
  defp gift(10), do: "ten Lords-a-Leaping"
  defp gift(11), do: "eleven Pipers Piping"
  defp gift(12), do: "twelve Drummers Drumming"

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    starting_verse..ending_verse
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end
end
