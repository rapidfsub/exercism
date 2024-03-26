defmodule RobotSimulator do
  @enforce_keys [:direction, :position]
  defstruct @enforce_keys

  @type robot() :: %__MODULE__{direction: direction(), position: position()}
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _position) when direction not in [:north, :east, :south, :west] do
    {:error, "invalid direction"}
  end

  def create(direction, {x, y}) when is_integer(x) and is_integer(y) do
    %__MODULE__{direction: direction, position: {x, y}}
  end

  def create(_direction, _position) do
    {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(%__MODULE__{} = robot, instructions) do
    instructions
    |> String.graphemes()
    |> Enum.reduce_while(robot, fn instruction, robot ->
      case robot |> do_simulate(instruction) do
        %__MODULE__{} = robot -> {:cont, robot}
        {:error, _reason} = error -> {:halt, error}
      end
    end)
  end

  defp do_simulate(%__MODULE__{} = robot, "A") do
    %{robot | position: robot.position |> next_position(robot.direction)}
  end

  defp do_simulate(%__MODULE__{} = robot, instruction) when instruction in ["L", "R"] do
    %{robot | direction: robot.direction |> next_direction(instruction)}
  end

  defp do_simulate(%__MODULE__{}, _instruction) do
    {:error, "invalid instruction"}
  end

  defp next_direction(:north, "L"), do: :west
  defp next_direction(:east, "L"), do: :north
  defp next_direction(:south, "L"), do: :east
  defp next_direction(:west, "L"), do: :south
  defp next_direction(:north, "R"), do: :east
  defp next_direction(:east, "R"), do: :south
  defp next_direction(:south, "R"), do: :west
  defp next_direction(:west, "R"), do: :north
  defp next_position({x, y}, :north), do: {x, y + 1}
  defp next_position({x, y}, :east), do: {x + 1, y}
  defp next_position({x, y}, :south), do: {x, y - 1}
  defp next_position({x, y}, :west), do: {x - 1, y}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(%__MODULE__{direction: direction}) do
    direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(%__MODULE__{position: position}) do
    position
  end
end
