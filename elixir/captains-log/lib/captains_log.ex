defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class() do
    @planetary_classes |> Enum.random()
  end

  def random_ship_registry_number() do
    ["NCC", 1000..1999 |> Enum.random()] |> Enum.join("-")
  end

  def random_stardate() do
    41000.0 + :rand.uniform() * 1000.0
  end

  def format_stardate(stardate) when is_float(stardate) do
    stardate
    |> Float.round(1)
    |> to_string()
  end

  def format_stardate(_stardate) do
    raise ArgumentError
  end
end
