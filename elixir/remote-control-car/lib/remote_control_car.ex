defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct @enforce_keys ++ [battery_percentage: 100, distance_driven_in_meters: 0]

  def new(nickname \\ "none") do
    %__MODULE__{nickname: nickname}
  end

  def display_distance(%__MODULE__{} = remote_car) do
    "#{remote_car.distance_driven_in_meters} meters"
  end

  def display_battery(%__MODULE__{} = remote_car) do
    if 0 < remote_car.battery_percentage do
      "Battery at #{remote_car.battery_percentage}%"
    else
      "Battery empty"
    end
  end

  def drive(%__MODULE__{} = remote_car) do
    if 0 < remote_car.battery_percentage do
      remote_car
      |> Map.update!(:distance_driven_in_meters, &(&1 + 20))
      |> Map.update!(:battery_percentage, &(&1 - 1))
    else
      remote_car
    end
  end
end
