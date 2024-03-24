defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: l |> do_count(0)
  defp do_count([], acc), do: acc
  defp do_count([_ | l], acc), do: l |> do_count(acc + 1)

  @spec reverse(list) :: list
  def reverse(l), do: l |> do_reverse([])
  defp do_reverse([], acc), do: acc
  defp do_reverse([h | t], acc), do: t |> do_reverse([h | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: l |> do_map(f, [])
  defp do_map([], _f, acc), do: acc |> reverse()
  defp do_map([h | t], f, acc), do: t |> do_map(f, [f.(h) | acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    l |> do_filter(f, [])
  end

  defp do_filter([], _f, acc) do
    acc |> reverse()
  end

  defp do_filter([h | t], f, acc) do
    if f.(h) do
      t |> do_filter(f, [h | acc])
    else
      t |> do_filter(f, acc)
    end
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _f), do: acc
  def foldl([h | t], acc, f), do: t |> foldl(h |> f.(acc), f)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr([], acc, _f), do: acc
  def foldr([h | t], acc, f), do: h |> f.(t |> foldr(acc, f))

  @spec append(list, list) :: list
  def append(a, b), do: [a, b] |> concat()

  @spec concat([[any]]) :: [any]
  def concat(ll), do: ll |> do_concat([])
  defp do_concat([[h | t] | ll], acc), do: [t | ll] |> do_concat([h | acc])
  defp do_concat([[] | ll], acc), do: ll |> do_concat(acc)
  defp do_concat([], acc), do: acc |> reverse()
end
