defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) when size > 0 do
    s
    |> String.graphemes()
    |> Stream.unfold(fn letters ->
      case Enum.take(letters, size) do
        result when length(result) == size -> {Enum.join(result), Enum.drop(letters, 1)}
        _ -> nil
      end
    end)
    |> Enum.to_list()
  end

  def slices(_s, _size) do
    []
  end
end
