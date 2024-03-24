defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?(dominoes) do
    dominoes
    |> Enum.with_index()
    |> chain?(dominoes |> length(), [], MapSet.new())
  end

  defp chain?(_with_index, 0, acc, _did_visit) do
    case {acc |> Enum.at(0), acc |> Enum.at(-1)} do
      {nil, nil} -> true
      {{num, _}, {_, num}} -> true
      _ -> false
    end
  end

  defp chain?(with_index, domino_len, acc, did_visit) do
    with_index
    |> Enum.reject(fn {_domino, index} -> did_visit |> MapSet.member?(index) end)
    |> Enum.any?(fn {{l, r} = domino, index} ->
      new_domino_len = domino_len - 1
      new_did_visit = did_visit |> MapSet.put(index)

      case acc do
        [] ->
          with_index |> chain?(new_domino_len, [domino], new_did_visit) or
            with_index |> chain?(new_domino_len, [{r, l}], new_did_visit)

        [{^r, _} | _] ->
          with_index |> chain?(new_domino_len, [domino | acc], new_did_visit)

        [{^l, _} | _] ->
          with_index |> chain?(new_domino_len, [{r, l} | acc], new_did_visit)

        _ ->
          false
      end
    end)
  end
end
