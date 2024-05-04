defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    factors
    |> Enum.filter(&(&1 > 0))
    |> Enum.flat_map(&(&1..(limit - 1)//&1))
    |> Enum.into(MapSet.new())
    |> Enum.sum()
  end
end
