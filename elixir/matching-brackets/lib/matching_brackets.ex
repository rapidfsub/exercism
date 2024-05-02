defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    String.graphemes(str) |> check_brackets([])
  end

  defp check_brackets([")" | str], ["(" | acc]), do: check_brackets(str, acc)
  defp check_brackets(["}" | str], ["{" | acc]), do: check_brackets(str, acc)
  defp check_brackets(["]" | str], ["[" | acc]), do: check_brackets(str, acc)
  defp check_brackets([h | _t], _acc) when h in ~w/] } )/, do: false
  defp check_brackets([h | t], acc) when h in ~w/( { [/, do: check_brackets(t, [h | acc])
  defp check_brackets([_h | t], acc), do: check_brackets(t, acc)
  defp check_brackets([], acc), do: Enum.empty?(acc)
end
