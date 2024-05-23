defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], w_max :: integer) :: integer
  def maximum_value([%{weight: w, value: v} | items], w_max) when w <= w_max do
    max(v + maximum_value(items, w_max - w), maximum_value(items, w_max))
  end

  def maximum_value([_item | items], w_max), do: maximum_value(items, w_max)
  def maximum_value([], _w_max), do: 0
end
