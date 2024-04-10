defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(number_string, size) when number_string |> is_binary() do
    number_string
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> largest_product(size)
  end

  def largest_product(digits, size) when digits |> is_list() do
    if 0 < size and digits |> length() >= size do
      digits
      |> Stream.unfold(fn digits ->
        case digits |> Enum.take(size) do
          window when window |> length() < size -> nil
          window -> {window |> Enum.product(), digits |> Enum.drop(1)}
        end
      end)
      |> Enum.max()
    else
      raise ArgumentError
    end
  end
end
