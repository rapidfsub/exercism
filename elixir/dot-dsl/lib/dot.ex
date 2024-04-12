defmodule Dot do
  defmacro graph(ast) do
    get_attrs = fn
      [attrs] ->
        cond do
          is_list(attrs) and Enum.all?(attrs, &is_tuple/1) -> attrs
          true -> raise ArgumentError
        end

      nil ->
        []

      _ ->
        raise ArgumentError
    end

    ast
    |> Macro.prewalk(
      quote do
        Graph.new()
      end,
      fn
        [do: {:__block__, _, ast}], acc ->
          {ast, acc}

        [do: ast], acc ->
          {[ast], acc}

        {:--, _, nodes}, acc ->
          case nodes do
            [{from, _, nil}, {to, _, nodes}] ->
              attrs = get_attrs.(nodes)

              {nil,
               quote do
                 unquote(acc) |> Graph.add_edge(unquote(from), unquote(to), unquote(attrs))
               end}

            _ ->
              raise ArgumentError
          end

        {:graph, _, nodes}, acc ->
          attrs = get_attrs.(nodes)

          {nil,
           quote do
             unquote(acc) |> Graph.put_attrs(unquote(attrs))
           end}

        {name, _, nodes}, acc ->
          attrs = get_attrs.(nodes)

          {nil,
           quote do
             unquote(acc) |> Graph.add_node(unquote(name), unquote(attrs))
           end}

        node, acc ->
          if is_list(node) and Enum.all?(ast, &match?({_, _, _}, &1)) do
            {node, acc}
          else
            raise ArgumentError
          end
      end
    )
    |> elem(1)
  end
end
