defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    with {:ok, acc} <- do_convert(input) do
      {:ok,
       acc
       |> Enum.reverse()
       |> Enum.map(&Enum.reverse/1)
       |> Enum.map_join(",", &to_string/1)}
    end
  end

  defp do_convert(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.reduce_while({:ok, []}, fn row, {:ok, acc} ->
      case convert_row(row) do
        {:ok, result} -> {:cont, {:ok, [result | acc]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp convert_row([_, _, _, _] = row) do
    row
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.chunk_every(&1, 3))
    |> Enum.zip()
    |> Enum.reduce_while({:ok, []}, fn cell, {:ok, acc} ->
      cell
      |> Tuple.to_list()
      |> Enum.map(&to_string/1)
      |> convert_digit()
      |> case do
        {:ok, result} -> {:cont, {:ok, [result | acc]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp convert_row(_input) do
    {:error, "invalid line count"}
  end

  @zero [
    " _ ",
    "| |",
    "|_|",
    "   "
  ]

  @one [
    "   ",
    "  |",
    "  |",
    "   "
  ]

  @two [
    " _ ",
    " _|",
    "|_ ",
    "   "
  ]

  @three [
    " _ ",
    " _|",
    " _|",
    "   "
  ]

  @four [
    "   ",
    "|_|",
    "  |",
    "   "
  ]

  @five [
    " _ ",
    "|_ ",
    " _|",
    "   "
  ]

  @six [
    " _ ",
    "|_ ",
    "|_|",
    "   "
  ]

  @seven [
    " _ ",
    "  |",
    "  |",
    "   "
  ]

  @eight [
    " _ ",
    "|_|",
    "|_|",
    "   "
  ]

  @nine [
    " _ ",
    "|_|",
    " _|",
    "   "
  ]

  defp convert_digit(@zero), do: {:ok, "0"}
  defp convert_digit(@one), do: {:ok, "1"}
  defp convert_digit(@two), do: {:ok, "2"}
  defp convert_digit(@three), do: {:ok, "3"}
  defp convert_digit(@four), do: {:ok, "4"}
  defp convert_digit(@five), do: {:ok, "5"}
  defp convert_digit(@six), do: {:ok, "6"}
  defp convert_digit(@seven), do: {:ok, "7"}
  defp convert_digit(@eight), do: {:ok, "8"}
  defp convert_digit(@nine), do: {:ok, "9"}
  defp convert_digit([<<_, _, _>>, <<_, _, _>>, <<_, _, _>>, <<_, _, _>>]), do: {:ok, "?"}
  defp convert_digit(_input), do: {:error, "invalid column count"}
end
