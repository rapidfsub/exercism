defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: any()

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school
  def new() do
    %{}
  end

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(school, String.t(), integer) :: {:ok | :error, school}
  def add(school, name, _grade) when is_map_key(school, name), do: {:error, school}
  def add(school, name, grade), do: {:ok, Map.put(school, name, grade)}

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school, integer) :: [String.t()]
  def grade(school, grade) do
    roster(school, fn _n, g -> g == grade end)
  end

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school) :: [String.t()]
  def roster(school) do
    roster(school, fn _n, _g -> true end)
  end

  defp roster(school, fun) do
    school
    |> Enum.filter(fn {name, grade} -> fun.(name, grade) end)
    |> Enum.sort_by(fn {name, grade} -> {grade, name} end)
    |> Enum.map(&elem(&1, 0))
  end
end
