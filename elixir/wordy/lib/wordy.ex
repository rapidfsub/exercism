defmodule Wordy do
  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t()) :: integer
  def answer(question) do
    with {:ok, tokens} <- lex(question), {:ok, result} <- exec(tokens) do
      result
    else
      _ -> raise ArgumentError
    end
  end

  defp lex(question) do
    case Regex.run(~r/^What is (.+)\?$/, question) do
      [_, question] -> do_lex(question)
      nil -> {:error, :invalid_question}
    end
  end

  defp do_lex(<<>>), do: {:ok, []}
  defp do_lex(<<" ", question::binary>>), do: do_lex(question)

  defp do_lex(question) do
    with {token, tail} <- lex_token(question), {:ok, tokens} <- do_lex(tail) do
      {:ok, [token | tokens]}
    else
      _ -> {:error, :invalid_token}
    end
  end

  defp lex_token(<<"plus", tail::binary>>), do: {{:op, &+/2}, tail}
  defp lex_token(<<"minus", tail::binary>>), do: {{:op, &-/2}, tail}
  defp lex_token(<<"multiplied by", tail::binary>>), do: {{:op, &*/2}, tail}
  defp lex_token(<<"divided by", tail::binary>>), do: {{:op, &div/2}, tail}

  defp lex_token(question) do
    with {val, tail} <- Integer.parse(question) do
      {{:val, val}, tail}
    end
  end

  defp exec(tokens) do
    exec(tokens, [])
  end

  defp exec([], [{:val, v}]), do: {:ok, v}
  defp exec([{:val, _v} = token | tokens], []), do: exec(tokens, [token])
  defp exec([{:op, fun}, {:val, r} | tokens], [{:val, l}]), do: exec(tokens, [{:val, fun.(l, r)}])
  defp exec(_tokens, _stack), do: {:error, :invalid_order}
end
