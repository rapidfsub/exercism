defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1, 2, 3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten([head | tail]) when head |> is_list() do
    head
    |> Enum.concat(tail)
    |> flatten()
  end

  def flatten([nil | tail]), do: tail |> flatten()
  def flatten([head | tail]), do: [head | tail |> flatten()]
  def flatten([]), do: []
end
