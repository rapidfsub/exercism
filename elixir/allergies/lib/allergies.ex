defmodule Allergies do
  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    Stream.unfold(1, &{&1, &1 * 2})
    |> Enum.take(8)
    |> Enum.filter(&(Bitwise.band(flags, &1) > 0))
    |> Enum.map(&from_flag/1)
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    item in list(flags)
  end

  defp from_flag(0x01), do: "eggs"
  defp from_flag(0x02), do: "peanuts"
  defp from_flag(0x04), do: "shellfish"
  defp from_flag(0x08), do: "strawberries"
  defp from_flag(0x10), do: "tomatoes"
  defp from_flag(0x20), do: "chocolate"
  defp from_flag(0x40), do: "pollen"
  defp from_flag(0x80), do: "cats"
end
