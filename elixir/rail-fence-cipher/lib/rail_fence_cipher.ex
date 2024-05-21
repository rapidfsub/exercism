defmodule RailFenceCipher do
  import Integer, only: [is_even: 1]

  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) when 1 < rails do
    period = get_period(rails)

    str
    |> String.graphemes()
    |> Enum.chunk_every(period, period, Stream.cycle([nil]))
    |> Enum.map(fn chunk ->
      [lhs, rhs] = Enum.chunk_every(chunk, rails - 1) |> Enum.map(&List.insert_at(&1, -1, nil))
      [lhs, Enum.reverse(rhs)] |> Enum.zip_with(&Enum.join/1)
    end)
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.join()
  end

  def encode(str, _rails) do
    str
  end

  defp get_period(rails) do
    (rails - 1) * 2
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) when 1 < rails do
    str
    |> get_lines(rails)
    |> List.update_at(0, &Enum.intersperse(&1, nil))
    |> List.update_at(-1, &[nil | Enum.intersperse(&1, nil)])
    |> Enum.map(&List.insert_at(&1, -1, nil))
    |> Enum.zip_with(&Enum.join/1)
    |> Enum.with_index(fn
      text, i when is_even(i) -> text
      text, _i -> String.reverse(text)
    end)
    |> to_string()
  end

  def decode(str, _rails) do
    str
  end

  defp get_lines(str, rails) do
    str
    |> get_counts(rails)
    |> Enum.map_reduce(String.graphemes(str), &Enum.split(&2, &1))
    |> elem(0)
  end

  defp get_counts(str, rails) do
    len = String.length(str)
    period = get_period(rails)
    quot = div(len, period)
    result = [quot | List.duplicate(2 * quot, rails - 2) ++ [quot]]

    1..rem(len, period)//1
    |> Enum.map(fn
      i when i < rails -> i - 1
      i -> rails - i - 1
    end)
    |> Enum.reduce(result, fn i, acc ->
      List.update_at(acc, i, &(&1 + 1))
    end)
  end
end
