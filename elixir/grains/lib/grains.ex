defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer()) :: {:ok, pos_integer()} | {:error, String.t()}
  def square(number) when number in 1..64, do: {:ok, 2 ** (number - 1)}
  def square(_number), do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: {:ok, pos_integer()}
  def total() do
    total =
      for number <- 1..64, {:ok, count} = number |> square() do
        count
      end
      |> Enum.sum()

    {:ok, total}
  end
end
