defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    coins
    |> Enum.sort(:desc)
    |> do_generate(target, [], 0, target + 1)
    |> case do
      nil -> {:error, "cannot change"}
      {result, _size} -> {:ok, result}
    end
  end

  defp do_generate(_coins, 0, acc, step, _size), do: {acc, step}
  defp do_generate([], _target, _acc, _step, _size), do: nil

  defp do_generate([head | tail] = coins, target, acc, step, size) do
    if target > 0 and step < size do
      case coins |> do_generate(target - head, [head | acc], step + 1, size) do
        {lhs, lsize} -> tail |> do_generate(target, acc, step, lsize) || {lhs, lsize}
        nil -> tail |> do_generate(target, acc, step, size)
      end
    end
  end
end
