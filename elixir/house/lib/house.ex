defmodule House do
  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    Enum.map(start..stop//1, &sentence/1) |> to_string()
  end

  defp sentence(number) do
    """
    This is #{complement(number)}.
    """
  end

  defp complement(number) do
    Enum.map(number..1//-1, &snippet/1) |> Enum.join(" ")
  end

  defp snippet(1), do: "the house that Jack built"
  defp snippet(2), do: "the malt that lay in"
  defp snippet(3), do: "the rat that ate"
  defp snippet(4), do: "the cat that killed"
  defp snippet(5), do: "the dog that worried"
  defp snippet(6), do: "the cow with the crumpled horn that tossed"
  defp snippet(7), do: "the maiden all forlorn that milked"
  defp snippet(8), do: "the man all tattered and torn that kissed"
  defp snippet(9), do: "the priest all shaven and shorn that married"
  defp snippet(10), do: "the rooster that crowed in the morn that woke"
  defp snippet(11), do: "the farmer sowing his corn that kept"
  defp snippet(12), do: "the horse and the hound and the horn that belonged to"
end
