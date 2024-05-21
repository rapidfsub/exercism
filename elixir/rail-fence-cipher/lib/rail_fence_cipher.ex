defmodule RailFenceCipher do
  import Integer, only: [is_even: 1]

  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) do
    Stream.concat(0..(rails - 1)//1, (rails - 2)..1//-1)
    |> Stream.cycle()
    |> Enum.zip(String.graphemes(str))
    |> Enum.reduce(%{}, fn {i, v}, acc -> Map.update(acc, i, [v], &[v | &1]) end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map_join(&(elem(&1, 1) |> Enum.reverse()))
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

  defp get_period(rails) do
    (rails - 1) * 2
  end
end
