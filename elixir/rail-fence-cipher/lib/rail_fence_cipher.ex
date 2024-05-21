defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) do
    str
    |> String.graphemes()
    |> do_encode(rails)
    |> to_string()
  end

  defp do_encode(enumerable, rails) do
    Stream.concat(0..(rails - 1)//1, (rails - 2)..1//-1)
    |> Stream.cycle()
    |> Enum.zip(enumerable)
    |> Enum.reduce(%{}, fn {i, v}, acc -> Map.update(acc, i, [v], &[v | &1]) end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&(elem(&1, 1) |> Enum.reverse()))
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    1..String.length(str)
    |> do_encode(rails)
    |> List.flatten()
    |> Enum.zip(String.graphemes(str))
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map_join(&elem(&1, 1))
  end
end
