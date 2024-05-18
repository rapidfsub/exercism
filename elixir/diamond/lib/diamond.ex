defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    {top, [pivot]} = top_half_lines(?A..letter) |> Enum.split(-1)
    [top, pivot, Enum.reverse(top)] |> to_string()
  end

  defp top_half_lines(letters) do
    len = Enum.count(letters)
    Enum.with_index(letters, &line(<<&1>>, &2, len))
  end

  defp line(letter, index, len) do
    right = (String.duplicate(" ", index) <> letter) |> String.pad_trailing(len, " ")
    {pivot, tail} = String.split_at(right, 1)
    String.reverse(tail) <> pivot <> tail <> "\n"
  end
end
