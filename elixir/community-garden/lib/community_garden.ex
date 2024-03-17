# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct @enforce_keys
end

defmodule CommunityGarden do
  defmodule State do
    @enforce_keys [:plots, :curr_id]
    defstruct @enforce_keys

    def new() do
      %__MODULE__{plots: [], curr_id: 0}
    end

    def get_plots(%__MODULE__{} = state) do
      state.plots
    end

    def register(%__MODULE__{} = state, register_to) do
      next_id = state.curr_id + 1
      plot = %Plot{plot_id: next_id, registered_to: register_to}
      {plot, %{state | plots: [plot | state.plots], curr_id: next_id}}
    end

    def release(%__MODULE__{} = state, plot_id) do
      %{state | plots: state.plots |> Enum.reject(&(&1.plot_id == plot_id))}
    end

    def get_registration(%__MODULE__{} = state, plot_id) do
      case state.plots |> Enum.find(&(&1.plot_id == plot_id)) do
        nil -> {:not_found, "plot is unregistered"}
        plot -> plot
      end
    end
  end

  def start(opts \\ []) do
    Agent.start(&State.new/0, opts)
  end

  def list_registrations(pid) do
    pid |> Agent.get(&State.get_plots/1)
  end

  def register(pid, register_to) do
    pid |> Agent.get_and_update(&State.register(&1, register_to))
  end

  def release(pid, plot_id) do
    pid |> Agent.update(&State.release(&1, plot_id))
  end

  def get_registration(pid, plot_id) do
    pid |> Agent.get(&State.get_registration(&1, plot_id))
  end
end
