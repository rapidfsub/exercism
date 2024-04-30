defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.split(~r/[^\p{L}']+/u, trim: true)
    |> Enum.map(fn <<first::binary-size(1), _::binary>> -> String.upcase(first) end)
    |> Enum.join()
  end
end
