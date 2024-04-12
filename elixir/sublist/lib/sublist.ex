defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    case {a |> sublist?(b), b |> sublist?(a)} do
      {true, true} -> :equal
      {true, false} -> :sublist
      {false, true} -> :superlist
      {false, false} -> :unequal
    end
  end

  defp sublist?(a, b) do
    len = a |> length()

    b
    |> Stream.unfold(fn l ->
      case l |> Enum.take(len) do
        element when element |> length() < len -> nil
        element -> {element, l |> Enum.drop(1)}
      end
    end)
    |> Enum.any?(&(&1 === a))
  end
end
