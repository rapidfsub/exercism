defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\p{L}\p{N}]/i, "")
    |> do_encode()
  end

  defp do_encode("") do
    ""
  end

  defp do_encode(str) do
    len = String.length(str)
    height = :math.sqrt(len) |> ceil()
    width = ceil(len / height)

    str
    |> String.pad_trailing(width * height, " ")
    |> String.graphemes()
    |> Enum.chunk_every(height)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.join(" ")
  end
end
