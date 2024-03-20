defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  defmodule State do
    @enforce_keys [:capacity, :queue]
    defstruct @enforce_keys

    def new(capacity) when capacity > 0 do
      %__MODULE__{capacity: capacity, queue: :queue.new()}
    end

    def read(%__MODULE__{} = state) do
      case state.queue |> :queue.out() do
        {{:value, value}, queue} -> {:ok, {value, %{state | queue: queue}}}
        {:empty, _queue} -> {:error, :empty}
      end
    end

    def write(%__MODULE__{} = state, item) do
      if state.queue |> :queue.len() < state.capacity do
        {:ok, %{state | queue: :queue.in(item, state.queue)}}
      else
        {:error, :full}
      end
    end

    def overwrite(%__MODULE__{} = state, item) do
      queue =
        if state.queue |> :queue.len() < state.capacity do
          state.queue
        else
          state.queue |> :queue.drop()
        end

      %{state | queue: :queue.in(item, queue)}
    end

    def clear(%__MODULE__{} = state) do
      %{state | queue: :queue.new()}
    end
  end

  use GenServer

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    __MODULE__ |> GenServer.start(capacity)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    buffer |> GenServer.call(:read)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    buffer |> GenServer.call({:write, item})
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    buffer |> GenServer.call({:overwrite, item})
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    buffer |> GenServer.call(:clear)
  end

  @impl GenServer
  def init(init_arg) do
    {:ok, State.new(init_arg)}
  end

  @impl GenServer
  def handle_call(:read, _from, state) do
    case state |> State.read() do
      {:ok, {value, new_state}} -> {:reply, {:ok, value}, new_state}
      {:error, _reason} = error -> {:reply, error, state}
    end
  end

  @impl GenServer
  def handle_call({:write, item}, _from, state) do
    case state |> State.write(item) do
      {:ok, new_state} -> {:reply, :ok, new_state}
      {:error, _reason} = error -> {:reply, error, state}
    end
  end

  @impl GenServer
  def handle_call({:overwrite, item}, _from, state) do
    {:reply, :ok, state |> State.overwrite(item)}
  end

  @impl GenServer
  def handle_call(:clear, _from, state) do
    {:reply, :ok, state |> State.clear()}
  end
end
