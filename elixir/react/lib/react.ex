defmodule React do
  defmodule State do
    @enforce_keys ~w[inputs outputs deps callbacks callback_deps]a
    defstruct @enforce_keys

    def new() do
      %__MODULE__{inputs: %{}, outputs: %{}, deps: %{}, callbacks: %{}, callback_deps: %{}}
    end

    def new(cells) do
      Enum.reduce(cells, new(), &put_cell(&2, &1)) |> update_outputs()
    end

    def put_cell(%__MODULE__{inputs: inputs} = s, {:input, name, value}) do
      %{s | inputs: Map.put(inputs, name, value)}
    end

    def put_cell(%__MODULE__{} = s, {:output, name, deps, fun}) do
      new_outputs = Map.put(s.outputs, name, %{deps: deps, fun: fun, val: nil})

      new_deps =
        Enum.reduce(deps, s.deps, fn dep, acc ->
          Map.update(acc, dep, [name], &[name | &1])
        end)

      %{s | outputs: new_outputs, deps: new_deps}
    end

    def get_value(%__MODULE__{inputs: i}, name) when is_map_key(i, name) do
      Map.fetch!(i, name)
    end

    def get_value(%__MODULE__{outputs: o}, name) when is_map_key(o, name) do
      Map.fetch!(o, name).val
    end

    def set_value(%__MODULE__{inputs: inputs} = s, name, value) do
      %{s | inputs: %{inputs | name => value}} |> update_deps(name)
    end

    def add_callback(%__MODULE__{} = s, dep, name, fun) do
      new_callbacks = Map.put(s.callbacks, name, %{dep: dep, fun: fun})
      new_callback_deps = Map.update(s.callback_deps, dep, [name], &[name | &1])
      %{s | callbacks: new_callbacks, callback_deps: new_callback_deps}
    end

    def remove_callback(%__MODULE__{} = s, cell_name, callback_name) do
      new_callbacks = Map.delete(s.callbacks, callback_name)
      new_callback_deps = Map.update!(s.callback_deps, cell_name, &List.delete(&1, callback_name))
      %{s | callbacks: new_callbacks, callback_deps: new_callback_deps}
    end

    defp update_outputs(%__MODULE__{outputs: outputs} = s) do
      do_update_outputs(s, Map.keys(outputs))
    end

    defp do_update_outputs(%__MODULE__{} = s, names) do
      Enum.reduce(names, s, &do_update_output(&2, &1))
    end

    defp do_update_output(%__MODULE__{outputs: outputs} = s, name) do
      output = Map.fetch!(outputs, name)

      case {output.val, calculate(s, name)} do
        {val, val} ->
          s

        {_old_val, new_val} ->
          new_output = %{output | val: new_val}

          %{s | outputs: %{outputs | name => new_output}}
          |> update_deps(name)
          |> execute_callbacks(name)
      end
    end

    defp update_deps(%__MODULE__{deps: deps} = s, name) do
      case Map.fetch(deps, name) do
        {:ok, deps} -> do_update_outputs(s, deps)
        :error -> s
      end
    end

    defp calculate(%__MODULE__{inputs: i}, name) when is_map_key(i, name) do
      Map.fetch!(i, name)
    end

    defp calculate(%__MODULE__{outputs: o} = s, name) when is_map_key(o, name) do
      output = Map.fetch!(o, name)
      args = Enum.map(output.deps, &calculate(s, &1))
      apply(output.fun, args)
    end

    defp execute_callbacks(%__MODULE__{} = s, name) do
      val = get_value(s, name)

      with {:ok, names} <- Map.fetch(s.callback_deps, name) do
        Enum.each(names, &do_execute_callback(s, &1, val))
      end

      s
    end

    defp do_execute_callback(%__MODULE__{callbacks: callbacks}, name, value) do
      Map.fetch!(callbacks, name).fun.(name, value)
      :ok
    end
  end

  use GenServer

  @opaque cells :: pid

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  @doc """
  Start a reactive system
  """
  @spec new(cells :: [cell]) :: {:ok, pid}
  def new(cells) do
    GenServer.start_link(__MODULE__, cells)
  end

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(cells :: pid, cell_name :: String.t()) :: any()
  def get_value(cells, cell_name) do
    GenServer.call(cells, {:get_value, cell_name})
  end

  @doc """
  Set the value of an input cell
  """
  @spec set_value(cells :: pid, cell_name :: String.t(), value :: any) :: :ok
  def set_value(cells, cell_name, value) do
    GenServer.call(cells, {:set_value, cell_name, value})
  end

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback) do
    GenServer.call(cells, {:add_callback, cell_name, callback_name, callback})
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, cell_name, callback_name) do
    GenServer.call(cells, {:remove_callback, cell_name, callback_name})
  end

  @impl GenServer
  def init(cells) do
    {:ok, State.new(cells)}
  end

  @impl GenServer
  def handle_call({:get_value, key}, _from, state) do
    {:reply, State.get_value(state, key), state}
  end

  @impl GenServer
  def handle_call({:set_value, key, value}, _from, state) do
    {:reply, :ok, State.set_value(state, key, value)}
  end

  @impl GenServer
  def handle_call({:add_callback, cell_name, callback_name, callback}, _from, state) do
    {:reply, :ok, State.add_callback(state, cell_name, callback_name, callback)}
  end

  @impl GenServer
  def handle_call({:remove_callback, cell_name, callback_name}, _from, state) do
    {:reply, :ok, State.remove_callback(state, cell_name, callback_name)}
  end
end
