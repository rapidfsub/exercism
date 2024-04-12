defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    numbers |> do_search(key, 0, tuple_size(numbers) - 1)
  end

  defp do_search(numbers, key, i, i) do
    case numbers |> elem(i) do
      ^key -> {:ok, i}
      _ -> :not_found
    end
  end

  defp do_search(numbers, key, i, j) when i < j do
    target = div(i + j, 2)

    {i, j} =
      case numbers |> elem(target) do
        ^key -> {target, target}
        number when number < key -> {target + 1, j}
        number when number > key -> {i, target}
      end

    numbers |> do_search(key, i, j)
  end

  defp do_search(_numbers, _key, _i, _j) do
    :not_found
  end
end
