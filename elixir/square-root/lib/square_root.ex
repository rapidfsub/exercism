defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) when radicand > 0 do
    radicand |> do_calculate(1)
  end

  defp do_calculate(radicand, result) do
    case abs(radicand - result * result) do
      error when error < 0.1 -> result |> round()
      _error -> radicand |> do_calculate((result + radicand / result) / 2)
    end
  end
end
