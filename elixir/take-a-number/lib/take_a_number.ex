defmodule TakeANumber do
  def start() do
    spawn(fn -> run(0) end)
  end

  defp run(number) when is_integer(number) do
    receive do
      {:report_state, pid} -> send(pid, number)
      {:take_a_number, pid} -> send(pid, number + 1)
      :stop -> nil
      _ -> number
    end
    |> case do
      nil -> nil
      next_state -> next_state |> run()
    end
  end
end
