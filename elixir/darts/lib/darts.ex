defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    r_square = x ** 2 + y ** 2

    cond do
      r_square > 100 -> 0
      r_square > 25 -> 1
      r_square > 1 -> 5
      true -> 10
    end
  end
end
