defmodule Matrix do
  @enforce_keys [:row_len, :col_len, :values]
  defstruct @enforce_keys

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    rows =
      for line <- input |> String.split("\n") do
        for digits <- line |> String.split(~r/\p{Z}/u) do
          digits |> String.to_integer()
        end
      end

    row_len = rows |> length()
    col_len = rows |> hd() |> length()

    values =
      for {row, r} <- rows |> Enum.with_index(1),
          {val, c} <- row |> Enum.with_index(1),
          into: %{} do
        {{r, c}, val}
      end

    %__MODULE__{row_len: row_len, col_len: col_len, values: values}
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    matrix
    |> rows()
    |> Enum.map_join("\n", &Enum.join(&1, " "))
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix) do
    for r <- 1..matrix.row_len do
      matrix |> row(r)
    end
  end

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index) do
    for c <- 1..matrix.col_len do
      matrix.values |> Map.fetch!({index, c})
    end
  end

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix) do
    for c <- 1..matrix.col_len do
      matrix |> column(c)
    end
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) do
    for r <- 1..matrix.row_len do
      matrix.values |> Map.fetch!({r, index})
    end
  end
end
