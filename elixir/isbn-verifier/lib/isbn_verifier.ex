defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    with [isbn] <- Regex.run(~r/^\p{N}{9}[\p{N}X]$/, String.replace(isbn, "-", "")) do
      isbn
      |> to_charlist()
      |> Enum.map(fn
        d when d in ?0..?9 -> d - ?0
        ?X -> 10
      end)
      |> Enum.with_index(fn d, i -> d * (10 - i) end)
      |> Enum.sum()
      |> rem(11) == 0
    end
  end
end
