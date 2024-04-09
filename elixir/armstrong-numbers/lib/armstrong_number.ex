defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = number |> Integer.digits()
    exp = digits |> length()

    digits
    |> Enum.map(&(&1 ** exp))
    |> Enum.sum() == number
  end
end
