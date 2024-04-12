defmodule BinarySearchTree do
  @enforce_keys [:data, :left, :right]
  defstruct @enforce_keys

  @type bst_node :: %__MODULE__{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %__MODULE__{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(%__MODULE__{} = tree, data) do
    tree |> do_insert(data)
  end

  defp do_insert(%__MODULE__{} = tree, data) when tree.data < data do
    %{tree | right: tree.right |> do_insert(data)}
  end

  defp do_insert(%__MODULE__{} = tree, data) do
    %{tree | left: tree.left |> do_insert(data)}
  end

  defp do_insert(nil, data) do
    data |> new()
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(%__MODULE__{} = tree) do
    tree
    |> do_in_order()
    |> List.flatten()
  end

  defp do_in_order(%__MODULE__{} = tree) do
    [do_in_order(tree.left), tree.data, do_in_order(tree.right)]
  end

  defp do_in_order(nil) do
    []
  end
end
