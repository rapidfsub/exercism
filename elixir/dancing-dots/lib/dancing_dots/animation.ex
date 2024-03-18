defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts :: opts()) :: {:ok, opts()} | {:error, error()}
  @callback handle_frame(dot :: dot(), frame_number :: frame_number(), opts :: opts()) :: dot()

  defmacro __using__(_opts) do
    quote do
      @behaviour DancingDots.Animation

      @impl DancingDots.Animation
      def init(opts) do
        {:ok, opts}
      end

      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _opts) do
    if frame_number |> rem(4) == 0 do
      dot |> Map.update!(:opacity, &(&1 / 2))
    else
      dot
    end
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  @impl DancingDots.Animation
  def init(opts) do
    case opts |> Keyword.get(:velocity) do
      velocity when is_number(velocity) ->
        {:ok, opts}

      velocity ->
        {:error,
         "The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"}
    end
  end

  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, opts) do
    velocity = opts |> Keyword.fetch!(:velocity)
    dot |> Map.update!(:radius, &(&1 + (frame_number - 1) * velocity))
  end
end
