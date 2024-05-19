defmodule Triplet do
  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum([_, _, _] = t) do
    Enum.sum(t)
  end

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product([_, _, _] = t) do
    Enum.product(t)
  end

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]) do
    pythagorean?(a, b, c)
  end

  defp pythagorean?(a, b, c) do
    a ** 2 + b ** 2 == c ** 2
  end

  @doc """
  Generates a list of pythagorean triplets whose values add up to a given sum.
  """
  @spec generate(non_neg_integer) :: [list(non_neg_integer)]
  def generate(sum) do
    cs = div(sum, 3)..(div(sum, 2) - 1)
    count = ceil(Enum.count(cs) / System.schedulers_online())

    cs
    |> Stream.chunk_every(count, count, [])
    |> Task.async_stream(fn cs ->
      for c <- cs,
          b <- ceil((sum - c) / 2)..c,
          a = sum - c - b,
          pythagorean?(a, b, c) do
        [a, b, c]
      end
    end)
    |> Stream.flat_map(&elem(&1, 1))
    |> Enum.sort()
  end
end
