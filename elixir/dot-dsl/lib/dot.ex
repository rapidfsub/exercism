defmodule Dot do
  defmacro graph(do: ast) do
    ast
    |> Macro.prewalk(
      Graph.new(),
      fn
        {:graph, _, [attrs]}, acc when is_list(attrs) ->
          {nil, acc |> Graph.put_attrs(attrs)}

        {:--, _, [{from, _, nil}, {to, _, [attrs]}]}, acc when is_list(attrs) ->
          {nil, acc |> Graph.add_edge(from, to, attrs)}

        {:--, _, [{from, _, nil}, {to, _, nil}]}, acc ->
          {nil, acc |> Graph.add_edge(from, to)}

        {name, _, [attrs]}, acc when is_list(attrs) ->
          {nil, acc |> Graph.add_node(name, attrs)}

        {name, _, nil}, acc ->
          {nil, acc |> Graph.add_node(name)}

        {_, _, _} = node, acc ->
          {node, acc}

        _node, _acc ->
          raise ArgumentError
      end
    )
    |> elem(1)
    |> Macro.escape()
  end
end
