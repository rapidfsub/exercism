defmodule Matrix do
  @enforce_keys [:row, :col, :data]
  defstruct @enforce_keys

  def vector(data) when data |> is_list() do
    %__MODULE__{
      row: 1,
      col: data |> length(),
      data:
        data
        |> Enum.with_index(fn x, c -> {{0, c}, x} end)
        |> Map.new()
    }
  end

  def clockwise(%__MODULE__{} = matrix) do
    %__MODULE__{
      row: matrix.col,
      col: matrix.row,
      data:
        matrix.data
        |> Map.new(fn {{r, c}, x} ->
          {{c, matrix.row - r - 1}, x}
        end)
    }
  end

  def concat(%__MODULE__{col: col} = lhs, %__MODULE__{col: col} = rhs) do
    %__MODULE__{
      row: lhs.row + rhs.row,
      col: col,
      data:
        rhs.data
        |> Map.new(fn {{r, c}, x} ->
          {{r + lhs.row, c}, x}
        end)
        |> Map.merge(lhs.data)
    }
  end

  def to_list(%__MODULE__{} = matrix) do
    for r <- 0..(matrix.row - 1)//1 do
      for c <- 0..(matrix.col - 1)//1 do
        matrix.data |> Map.fetch!({r, c})
      end
    end
  end
end

defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(dimension), do: do_matrix(dimension, dimension, 1) |> Matrix.to_list()

  defp do_matrix(1, 1, start) do
    [start] |> Matrix.vector()
  end

  defp do_matrix(row, col, start) when row >= 1 and col >= 1 do
    start..(start + col - 1)
    |> Enum.to_list()
    |> Matrix.vector()
    |> Matrix.concat(do_matrix(col, row - 1, start + col) |> Matrix.clockwise())
  end
end
