defmodule Luhn do
  import Integer, only: [is_odd: 1]

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) when number |> is_binary() do
    if number |> String.match?(~r/[^\p{N}\p{Zs}]/) do
      false
    else
      ~r/\p{N}/
      |> Regex.scan(number)
      |> Enum.map(fn [letter] -> letter |> String.to_integer() end)
      |> case do
        [0] ->
          false

        digits ->
          digits
          |> Enum.reverse()
          |> Enum.with_index(fn digit, index ->
            if index |> is_odd() do
              case digit * 2 do
                result when result < 10 -> result
                result -> result - 9
              end
            else
              digit
            end
          end)
          |> Enum.sum()
          |> rem(10) == 0
      end
    end
  end
end
