defmodule Matrix do
  @enforce_keys [:rows, :cols, :items]
  defstruct @enforce_keys

  def new(str) do
    lines = String.split(str, "\n", trim: true) |> Enum.map(&String.split(&1, " ", trim: true))

    items =
      for {line, row} <- Enum.with_index(lines, 1),
          {letter, col} <- Enum.with_index(line, 1),
          into: %{} do
        {{row, col}, String.to_integer(letter)}
      end

    %__MODULE__{rows: length(lines), cols: Enum.find_value(lines, 0, &length/1), items: items}
  end

  def rows(%__MODULE__{} = m) do
    for row <- 1..m.rows//1 do
      for col <- 1..m.cols//1 do
        Map.fetch!(m.items, {row, col})
      end
    end
  end

  def columns(%__MODULE__{} = m) do
    for col <- 1..m.cols//1 do
      for row <- 1..m.rows//1 do
        Map.fetch!(m.items, {row, col})
      end
    end
  end

  def saddle_points(%__MODULE__{} = m) do
    m.items
    |> Enum.filter(&saddle_point?(m, &1))
    |> Enum.map(&elem(&1, 0))
  end

  defp saddle_point?(%__MODULE__{} = m, {{row, col}, value}) do
    rows(m) |> Enum.fetch!(row - 1) |> Enum.max() == value and
      columns(m) |> Enum.fetch!(col - 1) |> Enum.min() == value
  end
end

defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    Matrix.new(str) |> Matrix.rows()
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    Matrix.new(str) |> Matrix.columns()
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    Matrix.new(str) |> Matrix.saddle_points()
  end
end
