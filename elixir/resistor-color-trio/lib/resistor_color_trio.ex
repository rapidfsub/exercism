defmodule ResistorColorTrio do
  @gig 10 ** 9
  @meg 10 ** 6
  @kil 10 ** 3

  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label(colors) do
    case colors |> get_value() do
      0 -> {0, :ohms}
      value when value |> rem(@gig) == 0 -> {value |> div(@gig), :gigaohms}
      value when value |> rem(@meg) == 0 -> {value |> div(@meg), :megaohms}
      value when value |> rem(@kil) == 0 -> {value |> div(@kil), :kiloohms}
      value -> {value, :ohms}
    end
  end

  defp get_value([c1, c2, c3 | _]) do
    (to_integer(c1) * 10 + to_integer(c2)) * 10 ** to_integer(c3)
  end

  defp to_integer(:black), do: 0
  defp to_integer(:brown), do: 1
  defp to_integer(:red), do: 2
  defp to_integer(:orange), do: 3
  defp to_integer(:yellow), do: 4
  defp to_integer(:green), do: 5
  defp to_integer(:blue), do: 6
  defp to_integer(:violet), do: 7
  defp to_integer(:grey), do: 8
  defp to_integer(:white), do: 9
end
