defmodule CollatzConjecture do
  import Integer, only: [is_even: 1]

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(1) do
    0
  end

  def calc(input) when input |> is_integer() and input > 1 do
    if input |> is_even() do
      input |> div(2) |> calc()
    else
      (input * 3 + 1) |> calc()
    end + 1
  end
end
