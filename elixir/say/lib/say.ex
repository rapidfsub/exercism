defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number < 0 or number >= 1_000_000_000_000 do
    {:error, "number is out of range"}
  end

  def in_english(number) when number >= 1_000_000_000 do
    do_in_english(number, 1_000_000_000, "billion")
  end

  def in_english(number) when number >= 1_000_000 do
    do_in_english(number, 1_000_000, "million")
  end

  def in_english(number) when number >= 1_000 do
    do_in_english(number, 1_000, "thousand")
  end

  def in_english(number) when number >= 100 do
    do_in_english(number, 100, "hundred")
  end

  def in_english(10), do: {:ok, "ten"}
  def in_english(11), do: {:ok, "eleven"}
  def in_english(12), do: {:ok, "twelve"}
  def in_english(13), do: {:ok, "thirteen"}
  def in_english(14), do: {:ok, "fourteen"}
  def in_english(15), do: {:ok, "fifteen"}
  def in_english(16), do: {:ok, "sixteen"}
  def in_english(17), do: {:ok, "seventeen"}
  def in_english(18), do: {:ok, "eighteen"}
  def in_english(19), do: {:ok, "nineteen"}
  def in_english(20), do: {:ok, "twenty"}
  def in_english(30), do: {:ok, "thirty"}
  def in_english(40), do: {:ok, "forty"}
  def in_english(50), do: {:ok, "fifty"}
  def in_english(60), do: {:ok, "sixty"}
  def in_english(70), do: {:ok, "seventy"}
  def in_english(80), do: {:ok, "eighty"}
  def in_english(90), do: {:ok, "ninety"}

  def in_english(number) when number >= 10 do
    [h, t] = Integer.digits(number)
    {:ok, head} = in_english(h * 10)
    {:ok, tail} = in_english(t)
    {:ok, head <> "-" <> tail}
  end

  def in_english(0), do: {:ok, "zero"}
  def in_english(1), do: {:ok, "one"}
  def in_english(2), do: {:ok, "two"}
  def in_english(3), do: {:ok, "three"}
  def in_english(4), do: {:ok, "four"}
  def in_english(5), do: {:ok, "five"}
  def in_english(6), do: {:ok, "six"}
  def in_english(7), do: {:ok, "seven"}
  def in_english(8), do: {:ok, "eight"}
  def in_english(9), do: {:ok, "nine"}

  defp do_in_english(number, divisor, unit) do
    {:ok, head} = div(number, divisor) |> in_english()

    result =
      case rem(number, divisor) do
        0 ->
          [head, unit]

        t ->
          {:ok, tail} = in_english(t)
          [head, unit, tail]
      end

    {:ok, Enum.join(result, " ")}
  end
end
