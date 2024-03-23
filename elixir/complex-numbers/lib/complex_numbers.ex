defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  import Kernel, except: [abs: 1, div: 2]

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real(a) do
    {r, _} = a |> to_complex!()
    r
  end

  defp to_complex!(num) when is_number(num), do: {num, 0}
  defp to_complex!({r, i}) when is_number(r) and is_number(i), do: {r, i}

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary(a) do
    {_, i} = a |> to_complex!()
    i
  end

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul(a, b) do
    {ar, ai} = a |> to_complex!()
    {br, bi} = b |> to_complex!()
    {ar * br - ai * bi, ai * br + ar * bi}
  end

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add(a, b) do
    {ar, ai} = a |> to_complex!()
    {br, bi} = b |> to_complex!()
    {ar + br, ai + bi}
  end

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub(a, b) do
    {br, bi} = b |> to_complex!()
    a |> add({-br, -bi})
  end

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div(a, b) when is_number(b) do
    a |> mul(1 / b)
  end

  def div(a, b) do
    {br, bi} = b = b |> to_complex!()

    a
    |> mul(conjugate(b))
    |> div(br ** 2 + bi ** 2)
  end

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs(a) do
    {r, i} = a |> to_complex!()
    (r ** 2 + i ** 2) |> :math.sqrt()
  end

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate(a) do
    {r, i} = a |> to_complex!()
    {r, -i}
  end

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp(a) do
    {r, i} = a |> to_complex!()
    {:math.cos(i), :math.sin(i)} |> mul(:math.exp(r))
  end
end
