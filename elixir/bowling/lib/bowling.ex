defmodule Frame do
  @enforce_keys [:i, :r1, :r2, :r3]
  defstruct @enforce_keys

  defguard is_game_done(f)
           when f.i == 10 and f.r1 != nil and f.r2 != nil and (f.r3 != nil or f.r1 + f.r2 < 10)

  def new() do
    %__MODULE__{i: 1, r1: nil, r2: nil, r3: nil}
  end

  def roll(%__MODULE__{}, pins) when pins < 0, do: {:error, "Negative roll is invalid"}
  def roll(%__MODULE__{}, pins) when pins > 10, do: {:error, "Pin count exceeds pins on the lane"}

  def roll(%__MODULE__{i: i, r3: nil} = f, pins) when i in 1..9 do
    case {f.r1, f.r2} do
      {nil, nil} -> {:curr, %{f | r1: pins}}
      {10, nil} -> {:next, %{f | i: f.i + 1, r1: pins}}
      {r1, nil} when r1 + pins <= 10 -> {:curr, %{f | r2: pins}}
      {_r1, nil} -> {:error, "Pin count exceeds pins on the lane"}
      {_r1, _r2} -> {:next, %{f | i: f.i + 1, r1: pins, r2: nil}}
    end
  end

  def roll(%__MODULE__{i: 10} = f, pins) do
    case {f.r1, f.r2, f.r3} do
      {nil, nil, nil} -> {:curr, %{f | r1: pins}}
      {10, nil, nil} -> {:curr, %{f | r2: pins}}
      {r1, nil, nil} when r1 + pins <= 10 -> {:curr, %{f | r2: pins}}
      {_r1, nil, nil} -> {:error, "Pin count exceeds pins on the lane"}
      {10, 10, nil} -> {:curr, %{f | r3: pins}}
      {10, r2, nil} when r2 + pins <= 10 -> {:curr, %{f | r3: pins}}
      {10, _r2, nil} -> {:error, "Pin count exceeds pins on the lane"}
      {r1, r2, nil} when r1 + r2 == 10 -> {:curr, %{f | r3: pins}}
      {_r1, _r2, _r3} -> {:error, "Cannot roll after game is over"}
    end
  end
end

defmodule Bowling do
  import Frame, only: [is_game_done: 1]

  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start do
    [Frame.new()]
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll([%Frame{} = f | fs] = game, roll) do
    case f |> Frame.roll(roll) do
      {:curr, frame} -> {:ok, [frame | fs]}
      {:next, frame} -> {:ok, [frame | game]}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @spec score(any) :: {:ok, integer} | {:error, String.t()}
  def score([%Frame{} = f | _]) when not is_game_done(f) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  def score(game) do
    game
    |> Enum.reverse()
    |> Stream.unfold(fn
      [] -> nil
      frames -> {frames, frames |> Enum.drop(1)}
    end)
    |> Enum.reduce({:ok, 0}, fn frames, {:ok, score} ->
      {:ok, score + do_score(frames)}
    end)
  end

  defp do_score([%Frame{i: 10} = f]) do
    f.r1 + f.r2 + (f.r3 || 0)
  end

  defp do_score([%Frame{r1: 10} | fs]) do
    case fs do
      [%Frame{r1: x, r2: nil}, %Frame{r1: y} | _] -> 10 + x + y
      [%Frame{r1: x, r2: y} | _] -> 10 + x + y
    end
  end

  defp do_score([%Frame{} = f, %Frame{r1: x} | _fs]) do
    case f.r1 + f.r2 do
      10 -> 10 + x
      score -> score
    end
  end
end
