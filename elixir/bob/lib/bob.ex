defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = String.trim(input)
    shouting = input == String.upcase(input) && input != String.downcase(input)
    asking = String.ends_with?(input, "?")
    String.trim(input) |> do_hey(shouting, asking)
  end

  defp do_hey("", _shouting, _asking), do: "Fine. Be that way!"
  defp do_hey(_input, true, true), do: "Calm down, I know what I'm doing!"
  defp do_hey(_input, true, false), do: "Whoa, chill out!"
  defp do_hey(_input, false, true), do: "Sure."
  defp do_hey(_input, false, false), do: "Whatever."
end
