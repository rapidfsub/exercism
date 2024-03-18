defmodule AutoShutdownTimeout do
  defmacro append_timeout(ast) do
    ast
    |> Macro.prewalk(fn
      {:@, _, [{a, {var, _, _} = state}]} when var in [:state, :new_state] ->
        quote do
          {unquote(a), unquote(state), unquote(state).auto_shutdown_timeout}
        end

      {:@, _, [{:{}, _, [a, b, {var, _, _} = state]}]} when var in [:state, :new_state] ->
        quote do
          {unquote(a), unquote(b), unquote(state), unquote(state).auto_shutdown_timeout}
        end

      ast ->
        ast
    end)
  end
end
