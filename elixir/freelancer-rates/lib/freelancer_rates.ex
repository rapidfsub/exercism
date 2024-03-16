defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    before_discount * (100.0 - discount) / 100.0
  end

  def monthly_rate(hourly_rate, discount) do
    monthly_rate(hourly_rate) |> apply_discount(discount) |> ceil()
  end

  defp monthly_rate(hourly_rate) do
    daily_rate(hourly_rate) * 22.0
  end

  def days_in_budget(budget, hourly_rate, discount) do
    rate = daily_rate(hourly_rate) |> apply_discount(discount)
    Float.floor(budget / rate, 1)
  end
end
