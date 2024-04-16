defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    Enum.sort([a, b, c]) |> kind()
  end

  defp kind([a, _b, _c]) when a <= 0, do: {:error, "all side lengths must be positive"}
  defp kind([a, b, c]) when a + b <= c, do: {:error, "side lengths violate triangle inequality"}
  defp kind([a, a, a]), do: {:ok, :equilateral}
  defp kind([a, a, _c]), do: {:ok, :isosceles}
  defp kind([_a, b, b]), do: {:ok, :isosceles}
  defp kind([_a, _b, _c]), do: {:ok, :scalene}
end
