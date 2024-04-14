defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    []
    |> run(code, 0x08, &["jump" | &1])
    |> run(code, 0x04, &["close your eyes" | &1])
    |> run(code, 0x02, &["double blink" | &1])
    |> run(code, 0x01, &["wink" | &1])
    |> run(code, 0x10, &Enum.reverse/1)
  end

  defp run(acc, code, bit, fun) do
    if Bitwise.band(code, bit) > 0 do
      fun.(acc)
    else
      acc
    end
  end
end
