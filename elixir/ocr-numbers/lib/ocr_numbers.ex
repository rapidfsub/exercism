defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    with {:ok, acc} <-
           input
           |> Enum.chunk_every(4)
           |> Enum.reduce_while({:ok, []}, fn input, {:ok, acc} ->
             case do_convert(input) do
               {:ok, result} -> {:cont, {:ok, [result | acc]}}
               {:error, reason} -> {:halt, {:error, reason}}
             end
           end) do
      {:ok,
       acc
       |> Enum.reverse()
       |> Enum.map(&Enum.reverse/1)
       |> Enum.map_join(",", &to_string/1)}
    end
  end

  defp do_convert([_, _, _, _] = input) do
    input
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.chunk_every(&1, 3))
    |> Enum.zip()
    |> Enum.reduce_while({:ok, []}, fn input, {:ok, acc} ->
      input
      |> Tuple.to_list()
      |> Enum.map(&to_string/1)
      |> convert_digit()
      |> case do
        {:ok, result} -> {:cont, {:ok, [result | acc]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp do_convert(_input) do
    {:error, "invalid line count"}
  end

  defp convert_digit([
         " _ ",
         "| |",
         "|_|",
         "   "
       ]) do
    {:ok, "0"}
  end

  defp convert_digit([
         "   ",
         "  |",
         "  |",
         "   "
       ]) do
    {:ok, "1"}
  end

  defp convert_digit([
         " _ ",
         " _|",
         "|_ ",
         "   "
       ]) do
    {:ok, "2"}
  end

  defp convert_digit([
         " _ ",
         " _|",
         " _|",
         "   "
       ]) do
    {:ok, "3"}
  end

  defp convert_digit([
         "   ",
         "|_|",
         "  |",
         "   "
       ]) do
    {:ok, "4"}
  end

  defp convert_digit([
         " _ ",
         "|_ ",
         " _|",
         "   "
       ]) do
    {:ok, "5"}
  end

  defp convert_digit([
         " _ ",
         "|_ ",
         "|_|",
         "   "
       ]) do
    {:ok, "6"}
  end

  defp convert_digit([
         " _ ",
         "  |",
         "  |",
         "   "
       ]) do
    {:ok, "7"}
  end

  defp convert_digit([
         " _ ",
         "|_|",
         "|_|",
         "   "
       ]) do
    {:ok, "8"}
  end

  defp convert_digit([
         " _ ",
         "|_|",
         " _|",
         "   "
       ]) do
    {:ok, "9"}
  end

  defp convert_digit([
         <<_, _, _>>,
         <<_, _, _>>,
         <<_, _, _>>,
         <<_, _, _>>
       ]) do
    {:ok, "?"}
  end

  defp convert_digit(_input) do
    {:error, "invalid column count"}
  end
end
