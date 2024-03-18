defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    {:ok, pid} = Task.start_link(fn -> input |> calculator.() end)
    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    result =
      receive do
        {:EXIT, ^pid, :normal} -> :ok
        {:EXIT, ^pid, _reason} -> :error
      after
        100 -> :timeout
      end

    results |> Map.put(input, result)
  end

  def reliability_check(calculator, inputs) do
    inputs
    |> Enum.map(fn input ->
      Task.async(fn ->
        Process.flag(:trap_exit, true)

        calculator
        |> start_reliability_check(input)
        |> await_reliability_check_result(%{})
      end)
    end)
    |> Task.await_many()
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(fn input ->
      Task.async(fn ->
        input |> calculator.()
      end)
    end)
    |> Task.await_many(100)
  end
end
