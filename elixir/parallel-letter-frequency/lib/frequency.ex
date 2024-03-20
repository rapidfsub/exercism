defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Task.async_stream(
      fn text ->
        text
        |> String.downcase()
        |> String.graphemes()
        |> Enum.filter(&String.match?(&1, ~r/\p{L}/))
        |> Enum.reduce(%{}, fn letter, acc ->
          acc |> Map.update(letter, 1, &(&1 + 1))
        end)
      end,
      ordered: false,
      max_concurrency: workers
    )
    |> Enum.reduce(%{}, fn
      {:ok, tally}, acc -> acc |> Map.merge(tally, fn _k, lhs, rhs -> lhs + rhs end)
      _, acc -> acc
    end)
  end
end
