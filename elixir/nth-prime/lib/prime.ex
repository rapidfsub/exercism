defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count > 0 do
    Stream.unfold(2, &{&1, &1 + 1})
    |> Stream.filter(&is_prime/1)
    |> Stream.drop(count - 1)
    |> Enum.take(1)
    |> hd()
  end

  defp is_prime(num) when num > 1 do
    sqrt =
      num
      |> :math.sqrt()
      |> floor()

    2..sqrt//1 |> Enum.all?(&(rem(num, &1) != 0))
  end
end
