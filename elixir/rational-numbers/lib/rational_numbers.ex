defmodule RationalNumbers do
  import Kernel, except: [abs: 1]

  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({na, da}, {nb, db}) do
    {na * db + nb * da, da * db} |> reduce()
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract(a, {nb, db}) do
    a |> add({-nb, db})
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({na, da}, {nb, db}) do
    {na * nb, da * db} |> reduce()
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by(a, {nb, db}) do
    a |> multiply({db, nb})
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({n, d}) do
    {n |> Kernel.abs(), d |> Kernel.abs()} |> reduce()
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({na, da}, n) when n < 0, do: {da, na} |> pow_rational(-n)
  def pow_rational({na, da}, n), do: {na ** n, da ** n} |> reduce()

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {n, d}) do
    x ** (n / d)
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({n, d}) when d < 0 do
    {-n, -d} |> reduce()
  end

  def reduce({n, d}) do
    gcd = Integer.gcd(n, d)
    {n |> div(gcd), d |> div(gcd)}
  end
end
