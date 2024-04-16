defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number > 0 do
    aliquot_sum = prime_factorization(number) |> Enum.sum()

    cond do
      number < aliquot_sum -> {:ok, :abundant}
      number > aliquot_sum -> {:ok, :deficient}
      true -> {:ok, :perfect}
    end
  end

  def classify(_number) do
    {:error, "Classification is only possible for natural numbers."}
  end

  defp prime_factorization(number) do
    trunc_sqrt = :math.sqrt(number) |> floor()

    1..trunc_sqrt
    |> Enum.flat_map(fn candid ->
      case {div(number, candid), rem(number, candid)} do
        {^candid, 0} -> [candid]
        {quot, 0} -> [candid, quot]
        _ -> []
      end
    end)
    |> Enum.sort(:desc)
    |> Enum.drop(1)
  end
end
