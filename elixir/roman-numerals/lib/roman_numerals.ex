defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) when number in 1..3999 do
    do_numeral(number)
  end

  defp do_numeral(n) when n >= 1000, do: "M" <> do_numeral(n - 1000)
  defp do_numeral(n) when n >= 900 or n in 400..499, do: "C" <> do_numeral(n + 100)
  defp do_numeral(n) when n >= 500, do: "D" <> do_numeral(n - 500)
  defp do_numeral(n) when n >= 100, do: "C" <> do_numeral(n - 100)
  defp do_numeral(n) when n >= 90 or n in 40..49, do: "X" <> do_numeral(n + 10)
  defp do_numeral(n) when n >= 50, do: "L" <> do_numeral(n - 50)
  defp do_numeral(n) when n >= 10, do: "X" <> do_numeral(n - 10)
  defp do_numeral(n) when n in [4, 9], do: "I" <> do_numeral(n + 1)
  defp do_numeral(n) when n >= 5, do: "V" <> do_numeral(n - 5)
  defp do_numeral(n) when n >= 1, do: "I" <> do_numeral(n - 1)
  defp do_numeral(0), do: ""
end
