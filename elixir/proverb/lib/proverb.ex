defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()

  def recite([head | _tail] = strings) do
    strings
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [curr, next] -> "For want of a #{curr} the #{next} was lost.\n" end)
    |> Enum.join()
    |> Kernel.<>("And all for the want of a #{head}.\n")
  end

  def recite([]) do
    ""
  end
end
