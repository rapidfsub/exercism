defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text
    |> to_charlist()
    |> Enum.map(fn
      l when l in ?a..?z -> do_rotate(l, shift, ?a)
      l when l in ?A..?Z -> do_rotate(l, shift, ?A)
      l -> l
    end)
    |> to_string()
  end

  @alphabet_len Enum.count(?a..?z)
  defp do_rotate(letter, shift, base) do
    rem(letter + shift - base, @alphabet_len) + base
  end
end
