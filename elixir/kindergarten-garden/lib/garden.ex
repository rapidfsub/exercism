defmodule Garden do
  @students ~w[alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry]a

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @students) do
    sections =
      info_string
      |> String.split("\n")
      |> Enum.map(fn row ->
        String.graphemes(row) |> Enum.chunk_every(2)
      end)
      |> Enum.zip()
      |> Enum.map(fn {r1, r2} ->
        Enum.map(r1 ++ r2, &plant/1) |> List.to_tuple()
      end)
      |> Stream.concat(Stream.cycle([{}]))

    student_names
    |> Enum.sort()
    |> Enum.zip(sections)
    |> Map.new()
  end

  defp plant("C"), do: :clover
  defp plant("G"), do: :grass
  defp plant("R"), do: :radishes
  defp plant("V"), do: :violets
end
