defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) when letter in ?A..?Z do
    len = letter - ?A + 1

    triangle =
      ?A..?Z
      |> Enum.take(len)
      |> Enum.with_index(fn l, i ->
        pad = List.duplicate(?\s, len - i - 1)
        {left, [pivot]} = [l | List.duplicate(?\s, i)] |> Enum.split(-1)
        [pad, left, pivot, Enum.reverse(left), pad, ?\n]
      end)

    triangle
    |> Enum.drop(-1)
    |> Enum.concat(Enum.reverse(triangle))
    |> to_string()
  end
end
