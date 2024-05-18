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
    a ** 2 + b ** 2 == c ** 2
  end

  @doc """
  Generates a list of pythagorean triplets whose values add up to a given sum.
  """
  @spec generate(non_neg_integer) :: [list(non_neg_integer)]
  def generate(sum) do
    cs = div(sum, 3)..div(sum, 2)
    count = ceil(Enum.count(cs) / System.schedulers_online())

    Stream.chunk_every(cs, count, count, [])
    |> Stream.map(fn cs ->
      for c <- cs, b <- ceil((sum - c) / 2)..(sum - c - 1) do
        [sum - c - b, b, c]
      end
    end)
    |> Task.async_stream(&Enum.filter(&1, fn x -> pythagorean?(x) end))
    |> Stream.flat_map(&elem(&1, 1))
    |> Enum.sort()
  end
end
