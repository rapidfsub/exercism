defmodule Forth do
  @enforce_keys [:stack, :customs]
  defstruct @enforce_keys

  @type operator() :: Forth.Parser.operator()
  @type parsed() :: Forth.Parser.parsed()
  @type parsed_or_customary() :: Forth.Parser.parsed_or_customary()
  @type evaluator() :: %__MODULE__{stack: [parsed()], customs: %{parsed() => [parsed()]}}

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator()
  def new() do
    %__MODULE__{stack: [], customs: %{}}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(ev :: evaluator(), s :: String.t()) :: evaluator()
  def eval(ev, s) do
    tokens = s |> Forth.Parser.run!()
    ev |> do_eval!(tokens)
  end

  @spec do_eval!(ev :: evaluator(), tokens :: [parsed_or_customary()]) :: evaluator()
  defp do_eval!(ev, [{:custom, key, args} | tokens]) do
    args = args |> substitute(ev)
    %{ev | customs: ev.customs |> Map.put(key, args)} |> do_eval!(tokens)
  end

  defp do_eval!(ev, [{:num, num} | tokens]) do
    %{ev | stack: [num | ev.stack]} |> do_eval!(tokens)
  end

  defp do_eval!(ev, [token | tokens]) when is_map_key(ev.customs, token) do
    args = ev.customs |> Map.fetch!(token)
    ev |> do_eval!(args ++ tokens)
  end

  defp do_eval!(ev, [token | tokens]) when token in ~w[add sub mul div]a do
    case ev.stack do
      [rhs, lhs | stack] ->
        operator = token |> to_operator()
        %{ev | stack: [operator.(lhs, rhs) | stack]} |> do_eval!(tokens)

      _ ->
        raise Forth.StackUnderflow
    end
  end

  defp do_eval!(ev, [:dup | tokens]) do
    case ev.stack do
      [arg | _] -> %{ev | stack: [arg | ev.stack]} |> do_eval!(tokens)
      _ -> raise Forth.StackUnderflow
    end
  end

  defp do_eval!(ev, [:drop | tokens]) do
    case ev.stack do
      [_ | stack] -> %{ev | stack: stack} |> do_eval!(tokens)
      _ -> raise Forth.StackUnderflow
    end
  end

  defp do_eval!(ev, [:swap | tokens]) do
    case ev.stack do
      [rhs, lhs | stack] -> %{ev | stack: [lhs, rhs | stack]} |> do_eval!(tokens)
      _ -> raise Forth.StackUnderflow
    end
  end

  defp do_eval!(ev, [:over | tokens]) do
    case ev.stack do
      [_, arg | _] -> %{ev | stack: [arg | ev.stack]} |> do_eval!(tokens)
      _ -> raise Forth.StackUnderflow
    end
  end

  defp do_eval!(ev, []) do
    ev
  end

  defp do_eval!(_ev, [{:word, _} | _tokens]) do
    raise Forth.UnknownWord
  end

  @spec substitute(args :: [parsed()], ev :: evaluator()) :: [parsed()]
  defp substitute(args, ev) do
    args
    |> Enum.flat_map(fn
      arg when is_map_key(ev.customs, arg) ->
        ev.customs
        |> Map.fetch!(arg)
        |> substitute(ev)

      arg ->
        [arg]
    end)
  end

  @spec to_operator(operator :: operator()) :: (integer(), integer() -> integer())
  defp to_operator(:add), do: &+/2
  defp to_operator(:sub), do: &-/2
  defp to_operator(:mul), do: &*/2

  defp to_operator(:div) do
    fn
      _dividend, 0 -> raise Forth.DivisionByZero
      dividend, divisor -> dividend |> div(divisor)
    end
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    ev.stack
    |> Enum.reverse()
    |> Enum.join(" ")
  end
end

defmodule Forth.Parser do
  @type operator() :: :add | :sub | :mul | :div
  @type lexed() ::
          :cln
          | :scln
          | :dup
          | :drop
          | :swap
          | :over
          | operator()
          | {:num, integer()}
          | {:word, binary()}

  @type parsed() ::
          :dup
          | :drop
          | :swap
          | :over
          | operator()
          | {:num, integer()}
          | {:word, binary()}

  @type customary_syntax() :: {:custom, parsed(), [parsed()]}
  @type parsed_or_customary() :: parsed() | customary_syntax()

  @spec run!(s :: binary()) :: [parsed_or_customary()]
  def run!(s) do
    s
    |> tokenize()
    |> Enum.map(&lex!/1)
    |> parse!()
  end

  @spec tokenize(s :: binary()) :: [binary()]
  defp tokenize(s) do
    s
    |> String.downcase()
    |> String.split(~r/[\p{Z}\p{C}]+/u, trim: true)
  end

  @spec lex!(binary()) :: lexed()
  defp lex!(":"), do: :cln
  defp lex!(";"), do: :scln
  defp lex!("+"), do: :add
  defp lex!("-"), do: :sub
  defp lex!("*"), do: :mul
  defp lex!("/"), do: :div
  defp lex!("dup"), do: :dup
  defp lex!("drop"), do: :drop
  defp lex!("swap"), do: :swap
  defp lex!("over"), do: :over

  @number ~r/^-?\d+$/
  @letter ~S"[^:;+\-*\/\p{Z}\p{C}]"
  @word ~r/^#{@letter}+(-#{@letter}+)*$/u
  defp lex!(token) do
    cond do
      token |> String.match?(@number) -> {:num, token |> String.to_integer()}
      token |> String.match?(@word) -> {:word, token}
    end
  end

  @spec parse!(tokens :: [lexed()]) :: [parsed_or_customary()]
  defp parse!([:cln | tokens]) do
    {[key | [_ | _] = args], [:scln | tokens]} = tokens |> Enum.split_while(&(&1 != :scln))

    case key do
      {:num, _num} -> raise Forth.InvalidWord
      _ -> [{:custom, key, args} | tokens |> parse!()]
    end
  end

  defp parse!([token | tokens]), do: [token | tokens |> parse!()]
  defp parse!([]), do: []
end

defmodule Forth.StackUnderflow do
  defexception []
  def message(_), do: "stack underflow"
end

defmodule Forth.InvalidWord do
  defexception word: nil
  def message(e), do: "invalid word: #{inspect(e.word)}"
end

defmodule Forth.UnknownWord do
  defexception word: nil
  def message(e), do: "unknown word: #{inspect(e.word)}"
end

defmodule Forth.DivisionByZero do
  defexception []
  def message(_), do: "division by zero"
end
