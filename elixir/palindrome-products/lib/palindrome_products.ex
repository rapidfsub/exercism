defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)

  def generate(max_factor, min_factor) when min_factor <= max_factor do
    cores = System.schedulers_online()

    0..(cores - 1)
    |> Task.async_stream(fn index ->
      for x <- (min_factor + index)..max_factor//cores,
          rem(x, 10) > 0,
          y <- x..max_factor//1,
          k = x * y,
          palindrome?(k) do
        {k, [x, y]}
      end
    end)
    |> Stream.flat_map(&elem(&1, 1))
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put_new(acc, k, []) |> Map.update!(k, &[v | &1])
    end)
  end

  def generate(_max_factor, _min_factor) do
    raise ArgumentError
  end

  defp palindrome?(n) do
    exp = :math.log10(n) |> trunc()
    do_palindrome?(n, 0, exp)
  end

  defp do_palindrome?(n, i, j) do
    i >= j or
      (div(n, 10 ** i) |> rem(10) == div(n, 10 ** j) |> rem(10) and
         do_palindrome?(n, i + 1, j - 1))
  end
end
