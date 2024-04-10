defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(_digits, input_base, _output_base) when input_base < 2 do
    {:error, "input base must be >= 2"}
  end

  def convert(_digits, _input_base, output_base) when output_base < 2 do
    {:error, "output base must be >= 2"}
  end

  def convert(digits, input_base, output_base) do
    digits
    |> Enum.all?(&(&1 >= 0 and &1 < input_base))
    |> if do
      result =
        digits
        |> Enum.reverse()
        |> Enum.zip_reduce(Stream.unfold(1, &{&1, &1 * input_base}), 0, fn lhs, rhs, acc ->
          lhs * rhs + acc
        end)
        |> Integer.digits(output_base)

      {:ok, result}
    else
      {:error, "all digits must be >= 0 and < input base"}
    end
  end
end
