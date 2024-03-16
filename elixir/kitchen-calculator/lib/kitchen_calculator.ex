defmodule KitchenCalculator do
  def get_volume(volume_pair) do
    volume_pair |> elem(1)
  end

  def to_milliliter(volume_pair) do
    {:milliliter, get_volume(volume_pair) * conversion_factor(volume_pair)}
  end

  defp conversion_factor(:milliliter), do: 1
  defp conversion_factor(:cup), do: 240
  defp conversion_factor(:fluid_ounce), do: 30
  defp conversion_factor(:teaspoon), do: 5
  defp conversion_factor(:tablespoon), do: 15
  defp conversion_factor(volume_pair), do: volume_pair |> elem(0) |> conversion_factor()

  def from_milliliter(volume_pair, unit) when volume_pair |> elem(0) == :milliliter do
    {unit, get_volume(volume_pair) / conversion_factor(unit)}
  end

  def convert(volume_pair, unit) do
    volume_pair |> to_milliliter() |> from_milliliter(unit)
  end
end
