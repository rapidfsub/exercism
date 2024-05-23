defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value(items, maximum_weight) do
    do_maximum_value(items, maximum_weight, 0, 0)
  end

  defp do_maximum_value([%{weight: dw, value: dv} | items], w_max, w, v) do
    case {do_maximum_value(items, w_max, w, v), do_maximum_value(items, w_max, w + dw, v + dv)} do
      {nil, nil} when w_max < w -> nil
      {nil, nil} -> v
      {nil, result} -> result
      {result, nil} -> result
      {lhs, rhs} -> max(lhs, rhs)
    end
  end

  defp do_maximum_value([], w_max, w, _v) when w_max < w, do: nil
  defp do_maximum_value([], _w_max, _w, v), do: v
end
