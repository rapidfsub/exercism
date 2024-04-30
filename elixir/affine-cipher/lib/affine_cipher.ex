defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @m Enum.count(?a..?z)

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    case Integer.gcd(a, @m) do
      1 ->
        result =
          message
          |> String.downcase()
          |> String.replace(~r/[^\p{Ll}\p{N}]/u, "")
          |> to_charlist()
          |> Enum.map(fn
            letter when letter in ?a..?z -> mod(a * (letter - ?a) + b, @m) + ?a
            letter when letter in ?0..?9 -> letter
          end)
          |> Enum.chunk_every(5)
          |> Enum.join(" ")

        {:ok, result}

      _ ->
        {:error, "a and m must be coprime."}
    end
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    case Integer.gcd(a, @m) do
      1 ->
        result =
          encrypted
          |> String.replace(" ", "")
          |> to_charlist()
          |> Enum.map(fn
            letter when letter in ?a..?z -> mod(mmi(a) * (letter - ?a - b), @m) + ?a
            letter when letter in ?0..?9 -> letter
          end)
          |> to_string()

        {:ok, result}

      _ ->
        {:error, "a and m must be coprime."}
    end
  end

  defp mmi(a, result \\ 1) when result <= 1_000_000 do
    case mod(a * result, @m) do
      1 -> result
      _ -> mmi(a, result + 1)
    end
  end

  defp mod(a, b) when a < 0, do: mod(a + b, b)
  defp mod(a, b), do: rem(a, b)
end
