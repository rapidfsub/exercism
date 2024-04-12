defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    for integer <- integers, byte <- do_encode(integer), into: <<>> do
      byte
    end
  end

  defp do_encode(n) do
    n
    |> Stream.unfold(&{rem(&1, 0x80), div(&1, 0x80)})
    |> Enum.take(ceil(bit_len(n) / 7))
    |> Enum.with_index(&<<min(&2, 1)::1, &1::7>>)
    |> Enum.reverse()
  end

  defp bit_len(n) do
    n = max(n, 1)
    trunc_log = :math.log2(n) |> floor()
    trunc_log + 1
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes) do
    bytes |> do_decode([])
  end

  defp do_decode(<<>>, []), do: {:ok, []}
  defp do_decode(<<>>, _acc), do: {:error, "incomplete sequence"}
  defp do_decode(<<1::1, n::7, rest::binary>>, acc), do: rest |> do_decode([n | acc])

  defp do_decode(<<0::1, n::7, rest::binary>>, acc) do
    with {:ok, integers} <- rest |> do_decode([]) do
      value =
        1
        |> Stream.unfold(&{&1, &1 * 0x80})
        |> Enum.zip_with([n | acc], &Kernel.*/2)
        |> Enum.sum()

      {:ok, [value | integers]}
    end
  end
end
