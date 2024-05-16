defmodule FoodChain do
  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    Enum.map(start..stop//1, &[opening(&1), closing(&1)]) |> Enum.join("\n")
  end

  defp closing(count) when count in 1..7 do
    [
      "She swallowed the cow to catch the goat.\n",
      "She swallowed the goat to catch the dog.\n",
      "She swallowed the dog to catch the cat.\n",
      "She swallowed the cat to catch the bird.\n",
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n",
      "She swallowed the spider to catch the fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ]
    |> Enum.take(-count)
  end

  defp closing(8) do
    ["She's dead, of course!\n"]
  end

  defp opening(1) do
    """
    I know an old lady who swallowed a fly.
    """
  end

  defp opening(2) do
    """
    I know an old lady who swallowed a spider.
    It wriggled and jiggled and tickled inside her.
    """
  end

  defp opening(3) do
    """
    I know an old lady who swallowed a bird.
    How absurd to swallow a bird!
    """
  end

  defp opening(4) do
    """
    I know an old lady who swallowed a cat.
    Imagine that, to swallow a cat!
    """
  end

  defp opening(5) do
    """
    I know an old lady who swallowed a dog.
    What a hog, to swallow a dog!
    """
  end

  defp opening(6) do
    """
    I know an old lady who swallowed a goat.
    Just opened her throat and swallowed a goat!
    """
  end

  defp opening(7) do
    """
    I know an old lady who swallowed a cow.
    I don't know how she swallowed a cow!
    """
  end

  defp opening(8) do
    """
    I know an old lady who swallowed a horse.
    """
  end
end
