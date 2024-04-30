defmodule PigLatin do
  @vowels ~w[a e i o u]

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(~r/\p{Z}+/u)
    |> Enum.map(&do_translate/1)
    |> Enum.join(" ")
  end

  defp do_translate(word) do
    case word do
      <<head::binary-1, _::binary>> when head in @vowels ->
        word <> "ay"

      <<h1::binary-1, h2::binary-1, _::binary>> when h1 in ~w[x y] and h2 not in @vowels ->
        word <> "ay"

      <<"qu", tail::binary>> ->
        do_translate(tail <> "qu")

      <<head::binary-1, tail::binary>> ->
        do_translate(tail <> head)
    end
  end
end
