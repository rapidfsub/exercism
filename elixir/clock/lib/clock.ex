defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) when abs(minute) >= 60 do
    carry = minute |> div(60)
    new(hour + carry, minute |> rem(60))
  end

  def new(hour, minute) when minute < 0 do
    new(hour - 1, minute + 60)
  end

  def new(hour, minute) when abs(hour) >= 24 do
    new(hour |> rem(24), minute)
  end

  def new(hour, minute) when hour < 0 do
    new(hour + 24, minute)
  end

  def new(hour, minute) do
    %__MODULE__{hour: hour, minute: minute}
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end

  defimpl String.Chars do
    import Kernel, except: [to_string: 1]

    def to_string(%Clock{hour: hour, minute: minute}) do
      [hour, minute]
      |> Enum.map_join(":", fn num ->
        num
        |> Kernel.to_string()
        |> String.pad_leading(2, "0")
      end)
    end
  end
end
