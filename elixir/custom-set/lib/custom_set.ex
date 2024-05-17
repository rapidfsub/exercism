defmodule CustomSet do
  defstruct map: %{}
  @opaque t :: %__MODULE__{map: map}

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    new() |> add_all(enumerable)
  end

  defp new() do
    %__MODULE__{}
  end

  @spec empty?(t) :: boolean
  def empty?(%__MODULE__{} = custom_set) do
    Enum.empty?(custom_set.map)
  end

  @spec contains?(t, any) :: boolean
  def contains?(%__MODULE__{} = custom_set, element) do
    Map.has_key?(custom_set.map, element)
  end

  @spec subset?(t, t) :: boolean
  def subset?(%__MODULE__{} = custom_set_1, %__MODULE__{} = custom_set_2) do
    members(custom_set_1) |> Enum.all?(&contains?(custom_set_2, &1))
  end

  defp members(%__MODULE__{} = custom_set) do
    Map.keys(custom_set.map)
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(%__MODULE__{} = custom_set_1, %__MODULE__{} = custom_set_2) do
    intersection(custom_set_1, custom_set_2).map |> Enum.empty?()
  end

  @spec equal?(t, t) :: boolean
  def equal?(%__MODULE__{} = custom_set_1, %__MODULE__{} = custom_set_2) do
    subset?(custom_set_1, custom_set_2) and subset?(custom_set_2, custom_set_1)
  end

  @spec add(t, any) :: t
  def add(%__MODULE__{} = custom_set, element) do
    %{custom_set | map: Map.put(custom_set.map, element, nil)}
  end

  defp add_all(%__MODULE__{} = custom_set, elements) do
    Enum.reduce(elements, custom_set, &add(&2, &1))
  end

  @spec intersection(t, t) :: t
  def intersection(%__MODULE__{} = custom_set_1, %__MODULE__{} = custom_set_2) do
    custom_set_1
    |> members()
    |> Enum.filter(&contains?(custom_set_2, &1))
    |> new()
  end

  @spec difference(t, t) :: t
  def difference(%__MODULE__{} = custom_set_1, %__MODULE__{} = custom_set_2) do
    custom_set_1
    |> members()
    |> Enum.reject(&contains?(custom_set_2, &1))
    |> new()
  end

  @spec union(t, t) :: t
  def union(%__MODULE__{} = custom_set_1, %__MODULE__{} = custom_set_2) do
    add_all(custom_set_1, members(custom_set_2))
  end
end
