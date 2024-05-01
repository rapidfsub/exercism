defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    encode(string, nil, nil)
  end

  defp encode(<<>>, nil, _c), do: ""
  defp encode(<<>>, l, 1), do: l
  defp encode(<<>>, l, c), do: to_string(c) <> l
  defp encode(<<h::binary-1, t::binary>>, nil, _c), do: encode(t, h, 1)
  defp encode(<<l::binary-1, t::binary>>, l, c), do: encode(t, l, c + 1)
  defp encode(<<h::binary-1, t::binary>>, l, 1), do: l <> encode(t, h, 1)
  defp encode(<<h::binary-1, t::binary>>, l, c), do: to_string(c) <> l <> encode(t, h, 1)

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    decode(string, nil)
  end

  defp decode(<<>>, nil), do: ""
  defp decode(<<h::8, t::binary>>, nil) when h in ?0..?9, do: decode(t, h - ?0)
  defp decode(<<h::binary-1, t::binary>>, nil), do: h <> decode(t, nil)
  defp decode(<<h::8, t::binary>>, c) when h in ?0..?9, do: decode(t, c * 10 + h - ?0)
  defp decode(<<h::binary-1, t::binary>>, c), do: String.duplicate(h, c) <> decode(t, nil)
end
