defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    2..limit//1
    |> Enum.to_list()
    |> do_primes_to(limit, [], MapSet.new())
  end

  defp do_primes_to([], _limit, acc, _did_visit) do
    acc |> Enum.reverse()
  end

  defp do_primes_to([head | tail], limit, acc, did_visit) do
    {acc, did_visit} =
      if did_visit |> MapSet.member?(head) do
        {acc, did_visit}
      else
        {[head | acc], head..limit//head |> Enum.into(did_visit)}
      end

    tail |> do_primes_to(limit, acc, did_visit)
  end
end
