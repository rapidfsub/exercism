defmodule TopSecret do
  def to_ast(string) do
    string |> Code.string_to_quoted!()
  end

  def decode_secret_message_part(ast, acc) do
    case ast |> do_decode() do
      nil -> {ast, acc}
      message -> {ast, [message | acc]}
    end
  end

  defp do_decode({key, _, [{:when, _, [{msg, _, args} | _]} | _]}) when key in [:def, :defp] do
    do_decode(msg, args)
  end

  defp do_decode({key, _, [{msg, _, args} | _]}) when key in [:def, :defp] do
    do_decode(msg, args)
  end

  defp do_decode(_ast) do
    nil
  end

  defp do_decode(msg, args) do
    msg
    |> to_string()
    |> String.graphemes()
    |> Enum.take(length(args || []))
    |> to_string()
  end

  def decode_secret_message(string) do
    string
    |> to_ast()
    |> Macro.prewalk([], &decode_secret_message_part/2)
    |> elem(1)
    |> Enum.reverse()
    |> to_string()
  end
end
