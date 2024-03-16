defmodule Secrets do
  def secret_add(secret) do
    new(&+/2, secret)
  end

  defp new(fun, secret) do
    &fun.(&1, secret)
  end

  def secret_subtract(secret) do
    new(&-/2, secret)
  end

  def secret_multiply(secret) do
    new(&*/2, secret)
  end

  def secret_divide(secret) do
    new(&div/2, secret)
  end

  def secret_and(secret) do
    new(&Bitwise.band/2, secret)
  end

  def secret_xor(secret) do
    new(&Bitwise.bxor/2, secret)
  end

  def secret_combine(secret_function1, secret_function2) do
    &(&1 |> secret_function1.() |> secret_function2.())
  end
end
