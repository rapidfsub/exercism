defmodule ResistorColorDuo do
  @doc """
  Calculate a resistance value from two colors
  """
  @spec value(colors :: [atom]) :: integer
  def value([c1, c2 | _]) do
    do_value(c1) * 10 + do_value(c2)
  end

  defp do_value(:black), do: 0
  defp do_value(:brown), do: 1
  defp do_value(:red), do: 2
  defp do_value(:orange), do: 3
  defp do_value(:yellow), do: 4
  defp do_value(:green), do: 5
  defp do_value(:blue), do: 6
  defp do_value(:violet), do: 7
  defp do_value(:grey), do: 8
  defp do_value(:white), do: 9
end
