defmodule AutoShutdownTimeout do
  defmacro def(call, expr) do
    expr =
      expr
      |> Macro.prewalk(fn
        {:^, _, [{e1, state}]} ->
          quote do
            {unquote(e1), unquote(state), unquote(state).auto_shutdown_timeout}
          end

        {:^, _, [{:{}, _, [e1, e2, state]}]} ->
          quote do
            {unquote(e1), unquote(e2), unquote(state), unquote(state).auto_shutdown_timeout}
          end

        ast ->
          ast
      end)

    quote do
      Kernel.def(unquote(call), unquote(expr))
    end
  end
end

defmodule TakeANumberDeluxe do
  alias TakeANumberDeluxe.State
  import Kernel, except: [def: 2]
  import AutoShutdownTimeout, only: [def: 2]
  use GenServer

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    __MODULE__ |> GenServer.start_link(init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    machine |> GenServer.call(:report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    machine |> GenServer.call(:queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    machine |> GenServer.call({:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    machine |> GenServer.call(:reset_state)
  end

  # Server callbacks

  @impl GenServer
  def init(init_arg) do
    min_n = init_arg |> Keyword.get(:min_number)
    max_n = init_arg |> Keyword.get(:max_number)
    timeout = init_arg |> Keyword.get(:auto_shutdown_timeout)

    result =
      if timeout do
        State.new(min_n, max_n, timeout)
      else
        State.new(min_n, max_n)
      end

    with {:ok, state} <- result do
      ^{:ok, state}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _from, state) do
    ^{:reply, state, state}
  end

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    case state |> State.queue_new_number() do
      {:ok, num, new_state} -> ^{:reply, {:ok, num}, new_state}
      {:error, _reason} = error -> ^{:reply, error, state}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority}, _from, state) do
    case state |> State.serve_next_queued_number(priority) do
      {:ok, num, new_state} -> ^{:reply, {:ok, num}, new_state}
      {:error, _reason} = error -> ^{:reply, error, state}
    end
  end

  @impl GenServer
  def handle_call(:reset_state, _from, state) do
    {:ok, state} = State.new(state.min_number, state.max_number, state.auto_shutdown_timeout)
    ^{:reply, :ok, state}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def handle_info(_msg, state) do
    ^{:noreply, state}
  end
end
