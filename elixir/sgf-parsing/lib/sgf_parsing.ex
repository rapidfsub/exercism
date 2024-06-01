defmodule SgfParsing do
  defmodule Sgf do
    defstruct properties: %{}, children: []
    @type t :: %__MODULE__{properties: map(), children: [t()]}

    def new(%{} = properties, children) when is_list(children) do
      %__MODULE__{properties: properties, children: children}
    end
  end

  @type sgf :: Sgf.t()

  @doc """
  Parse a string into a Smart Game Format tree
  """
  @spec parse(encoded :: String.t()) :: {:ok, sgf} | {:error, String.t()}
  def parse(encoded) do
    lex(encoded) |> parse_tree()
  end

  defp lex(input) do
    String.graphemes(input) |> do_lex([], [])
  end

  defp do_lex([x | input], acc, [{:term, "["} | _] = res) when x in ~w/[ ( ; )/ do
    do_lex(input, [x | acc], res)
  end

  @terminals ~w/( ) [ ] ;/
  defp do_lex([t | input], acc, res) when t in @terminals do
    case acc do
      [] -> do_lex(input, [], [{:term, t} | res])
      acc -> do_lex(input, [], [{:term, t}, acc_to_token(acc) | res])
    end
  end

  defp do_lex(["\\", "\t" | input], acc, res), do: do_lex(input, [" " | acc], res)
  defp do_lex(["\\", "\n" | input], acc, res), do: do_lex(input, acc, res)

  defp do_lex(["\\" | input], acc, res) do
    case input do
      [x | xs] when x in ~w/t n \\ ]/ -> do_lex(xs, [x | acc], res)
    end
  end

  defp do_lex(["\t" | input], acc, res), do: do_lex(input, [" " | acc], res)
  defp do_lex([x | input], acc, res), do: do_lex(input, [x | acc], res)
  defp do_lex([], [], res), do: Enum.reverse(res)
  defp do_lex([], acc, res), do: do_lex([], [], [acc_to_token(acc) | res])

  defp acc_to_token(acc) do
    {:text, Enum.reverse(acc) |> to_string()}
  end

  defp parse_tree(tokens) do
    case Enum.split(tokens, -1) do
      {[{:term, "("} | tokens], [term: ")"]} -> parse_node(tokens)
      {_, _} -> {:error, "tree missing"}
    end
  end

  defp parse_node([{:term, ";"} | tokens]) do
    with {:ok, {properties, tokens}} <- parse_properties(tokens),
         {:ok, children} <- parse_children(tokens) do
      {:ok, Sgf.new(properties, children)}
    end
  end

  defp parse_node(_tokens) do
    {:error, "tree with no nodes"}
  end

  defp parse_properties(tokens) do
    do_parse_properties(tokens, %{})
  end

  defp do_parse_properties([{:text, key} | tokens], acc) do
    if key == String.upcase(key) do
      case parse_values(tokens) do
        {:ok, {[], _tokens}} -> {:error, "properties without delimiter"}
        {:ok, {values, tokens}} -> do_parse_properties(tokens, Map.put(acc, key, values))
      end
    else
      {:error, "property must be in uppercase"}
    end
  end

  defp do_parse_properties(tokens, acc) do
    {:ok, {acc, tokens}}
  end

  defp parse_values([{:term, "["}, {:text, value}, {:term, "]"} | tokens]) do
    with {:ok, {values, tokens}} <- parse_values(tokens) do
      {:ok, {[value | values], tokens}}
    end
  end

  defp parse_values(tokens) do
    {:ok, {[], tokens}}
  end

  defp parse_children([{:term, ";"} | _] = tokens) do
    with {:ok, node} <- parse_node(tokens) do
      {:ok, [node]}
    end
  end

  defp parse_children(tokens) do
    parse_nodes(tokens)
  end

  defp parse_nodes([]) do
    {:ok, []}
  end

  defp parse_nodes(tokens) do
    do_parse_nodes(tokens, [], [])
  end

  defp do_parse_nodes(tokens, [{:term, ")"} | _] = acc, []) do
    with {:ok, node} <- Enum.reverse(acc) |> parse_tree(),
         {:ok, nodes} <- do_parse_nodes(tokens, [], []) do
      {:ok, [node | nodes]}
    end
  end

  defp do_parse_nodes([{:term, "("} = paren | tokens], acc, parens) do
    do_parse_nodes(tokens, [paren | acc], [paren | parens])
  end

  defp do_parse_nodes([{:term, ")"} = paren | tokens], acc, parens) do
    case parens do
      [{:term, "("} | parens] -> do_parse_nodes(tokens, [paren | acc], parens)
    end
  end

  defp do_parse_nodes([token | tokens], acc, parens) do
    do_parse_nodes(tokens, [token | acc], parens)
  end

  defp do_parse_nodes([], [], []) do
    {:ok, []}
  end
end
