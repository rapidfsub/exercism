defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    @default_msg "stack underflow occurred"
    defexception message: @default_msg

    @impl Exception
    def exception([]) do
      %__MODULE__{}
    end

    @impl Exception
    def exception(ctx) when is_binary(ctx) do
      %__MODULE__{message: "stack underflow occurred, context: " <> ctx}
    end
  end

  def divide([0, _dividend]) do
    raise DivisionByZeroError
  end

  def divide([divisor, dividend]) do
    dividend |> div(divisor)
  end

  def divide(_stack) do
    raise StackUnderflowError, "when dividing"
  end
end
