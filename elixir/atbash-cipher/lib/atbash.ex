defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> transform()
    |> Enum.chunk_every(5)
    |> Enum.join(" ")
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    transform(cipher) |> to_string()
  end

  defp transform(text) do
    text
    |> String.downcase()
    |> to_charlist()
    |> Enum.flat_map(fn
      l when l in ?0..?9 -> [l]
      l when l in ?a..?z -> [?z - l + ?a]
      _l -> []
    end)
  end
end
