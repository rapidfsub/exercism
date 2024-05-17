defmodule FoodChain do
  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    Enum.map(start..stop//1, &stanza/1) |> Enum.join("\n")
  end

  defp stanza(index) do
    [opening(index), middle(index), ending(index)] |> to_string()
  end

  defp opening(index) do
    "I know an old lady who swallowed a #{food(index)}.\n"
  end

  defp food(1), do: "fly"
  defp food(2), do: "spider"
  defp food(3), do: "bird"
  defp food(4), do: "cat"
  defp food(5), do: "dog"
  defp food(6), do: "goat"
  defp food(7), do: "cow"
  defp food(8), do: "horse"

  defp middle(1), do: ""
  defp middle(2), do: "It wriggled and jiggled and tickled inside her.\n"
  defp middle(3), do: "How absurd to swallow a bird!\n"
  defp middle(4), do: "Imagine that, to swallow a cat!\n"
  defp middle(5), do: "What a hog, to swallow a dog!\n"
  defp middle(6), do: "Just opened her throat and swallowed a goat!\n"
  defp middle(7), do: "I don't know how she swallowed a cow!\n"
  defp middle(8), do: ""

  defp ending(8) do
    "She's dead, of course!\n"
  end

  defp ending(index) when index in 1..7 do
    index..1//-1
    |> Enum.map(&food/1)
    |> Enum.chunk_every(2, 1, Stream.cycle([nil]))
    |> Enum.map(fn [curr, prev] -> reason(curr, prev) end)
  end

  defp reason("fly", nil) do
    "I don't know why she swallowed the fly. Perhaps she'll die.\n"
  end

  defp reason("bird", "spider") do
    reason("bird", "spider that wriggled and jiggled and tickled inside her")
  end

  defp reason(curr, prev) do
    "She swallowed the #{curr} to catch the #{prev}.\n"
  end
end
