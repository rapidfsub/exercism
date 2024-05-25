defmodule Zipper do
  @enforce_keys [:node, :path]
  defstruct @enforce_keys

  @type t :: %__MODULE__{}

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %__MODULE__{node: bin_tree, path: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%__MODULE__{} = z) do
    case up(z) do
      nil -> z.node
      zipper -> to_tree(zipper)
    end
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%__MODULE__{} = z) do
    z.node.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%__MODULE__{} = z) do
    case z.node.left do
      nil -> nil
      l -> %{z | node: l, path: [(&%{z.node | left: &1}) | z.path]}
    end
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%__MODULE__{} = z) do
    case z.node.right do
      nil -> nil
      r -> %{z | node: r, path: [(&%{z.node | right: &1}) | z.path]}
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%__MODULE__{} = z) do
    case z.path do
      [fun | path] -> Map.update!(%{z | path: path}, :node, fun)
      [] -> nil
    end
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%__MODULE__{} = z, value) do
    %{z | node: %{z.node | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%__MODULE__{} = z, left) do
    %{z | node: %{z.node | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%__MODULE__{} = z, right) do
    %{z | node: %{z.node | right: right}}
  end
end
