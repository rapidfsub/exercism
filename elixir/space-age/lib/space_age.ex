defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @earth_year_in_seconds 31_557_600

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet', or an error if 'planet' is not a planet.
  """
  @spec age_on(planet, pos_integer) :: {:ok, float} | {:error, String.t()}
  def age_on(planet, seconds) do
    with {:ok, factor} <- planet |> period_ratio() do
      {:ok, seconds / factor / @earth_year_in_seconds}
    end
  end

  defp period_ratio(:mercury), do: {:ok, 0.2408467}
  defp period_ratio(:venus), do: {:ok, 0.61519726}
  defp period_ratio(:mars), do: {:ok, 1.8808158}
  defp period_ratio(:jupiter), do: {:ok, 11.862615}
  defp period_ratio(:saturn), do: {:ok, 29.447498}
  defp period_ratio(:uranus), do: {:ok, 84.016846}
  defp period_ratio(:neptune), do: {:ok, 164.79132}
  defp period_ratio(:earth), do: {:ok, 1.0}
  defp period_ratio(_planet), do: {:error, "not a planet"}
end
