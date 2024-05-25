defmodule TwoBucket do
  defstruct [:bucket_one, :bucket_two, :moves]
  @type t :: %TwoBucket{bucket_one: integer, bucket_two: integer, moves: integer}

  @doc """
  Find the quickest way to fill a bucket with some amount of water from two buckets of specific sizes.
  """
  @spec measure(s1 :: integer, s2 :: integer, goal :: integer, start_bucket :: :one | :two) ::
          {:ok, TwoBucket.t()} | {:error, :impossible}
  def measure(s1, s2, goal, :one) do
    if available?(goal, s1, s2) do
      {:ok, do_measure({0, 0, 0}, {s1, s2}, goal) |> new()}
    else
      {:error, :impossible}
    end
  end

  def measure(s1, s2, goal, :two) do
    with {:ok, tb} <- measure(s2, s1, goal, :one) do
      {:ok, swap(tb)}
    end
  end

  defp do_measure({goal, _, _} = result, _sp, goal), do: result
  defp do_measure({_, goal, _} = result, _sp, goal), do: result
  defp do_measure({0, b2, m}, {s1, _s2} = sp, goal), do: {s1, b2, m + 1} |> do_measure(sp, goal)
  defp do_measure({b1, 0, m}, {_s1, s2}, s2), do: {b1, s2, m + 1}
  defp do_measure({b1, s2, m}, {_s1, s2} = sp, goal), do: {b1, 0, m + 1} |> do_measure(sp, goal)

  defp do_measure({b1, b2, m}, {_s1, s2} = sp, goal) do
    diff = min(b1, s2 - b2)
    {b1 - diff, b2 + diff, m + 1} |> do_measure(sp, goal)
  end

  defp available?(goal, s1, s2) do
    goal in [s1, s2 | Stream.unfold(s1, &{rem(&1, s2), &1 + s1}) |> Enum.take_while(&(&1 > 0))]
  end

  defp new({bucket_one, bucket_two, moves}) do
    %__MODULE__{bucket_one: bucket_one, bucket_two: bucket_two, moves: moves}
  end

  defp swap(%__MODULE__{bucket_one: bucket_one, bucket_two: bucket_two} = tb) do
    %{tb | bucket_one: bucket_two, bucket_two: bucket_one}
  end
end
