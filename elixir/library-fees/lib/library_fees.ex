defmodule LibraryFees do
  def datetime_from_string(string) do
    string |> NaiveDateTime.from_iso8601!()
  end

  def before_noon?(datetime) do
    datetime
    |> NaiveDateTime.to_time()
    |> Time.compare(~T[12:00:00]) == :lt
  end

  def return_date(checkout_datetime) do
    offset =
      if checkout_datetime |> before_noon?() do
        28
      else
        29
      end

    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.add(offset)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> max(0)
  end

  def monday?(datetime) do
    datetime |> Date.day_of_week() == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    return = return |> datetime_from_string()

    result =
      checkout
      |> datetime_from_string()
      |> return_date()
      |> days_late(return)
      |> Kernel.*(rate)

    if return |> monday?() do
      result |> div(2)
    else
      result
    end
  end
end
