defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    day_of_week = day_of_week(weekday)

    days =
      Date.new!(year, month, 1)
      |> Stream.unfold(&{&1, Date.add(&1, 1)})
      |> Enum.take_while(&(&1.month == month))
      |> Enum.filter(&(Date.day_of_week(&1) == day_of_week))

    case schedule do
      :first -> Enum.fetch!(days, 0)
      :second -> Enum.fetch!(days, 1)
      :third -> Enum.fetch!(days, 2)
      :fourth -> Enum.fetch!(days, 3)
      :last -> Enum.fetch!(days, -1)
      :teenth -> Enum.find(days, &(&1.day in 13..19))
    end
  end

  defp day_of_week(:monday), do: 1
  defp day_of_week(:tuesday), do: 2
  defp day_of_week(:wednesday), do: 3
  defp day_of_week(:thursday), do: 4
  defp day_of_week(:friday), do: 5
  defp day_of_week(:saturday), do: 6
  defp day_of_week(:sunday), do: 7
end
