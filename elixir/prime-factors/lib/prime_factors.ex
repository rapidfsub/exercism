defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    number |> factors_for(2, [])
  end

  defp factors_for(num, divisor, acc) when rem(num, divisor) == 0 do
    next_num = num |> div(divisor)

    if next_num |> prime?() do
      [next_num, divisor | acc] |> Enum.reverse()
    else
      next_num |> factors_for(divisor, [divisor | acc])
    end
  end

  defp factors_for(num, divisor, acc) when divisor < num, do: num |> factors_for(divisor + 1, acc)
  defp factors_for(1, _divisor, acc), do: acc |> Enum.reverse()

  defp prime?(number) when number < 2 do
    false
  end

  defp prime?(number) do
    sqrt =
      number
      |> :math.sqrt()
      |> floor()

    2..sqrt//1 |> Enum.all?(&(number |> rem(&1) != 0))
  end
end
