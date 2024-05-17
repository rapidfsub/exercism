defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}
  def build_tree(preorder, inorder) do
    pre_set = MapSet.new(preorder)
    pre_len = length(preorder)
    in_set = MapSet.new(inorder)
    in_len = length(inorder)

    cond do
      pre_len != in_len -> {:error, "traversals must have the same length"}
      pre_set != in_set -> {:error, "traversals must have the same elements"}
      Enum.count(pre_set) != pre_len -> {:error, "traversals must contain unique items"}
      true -> {:ok, do_build_tree(preorder, inorder)}
    end
  end

  defp do_build_tree([], []) do
    {}
  end

  defp do_build_tree([root | pre_nodes], inorder) do
    {in_l, [^root | in_r]} = Enum.split_while(inorder, &(&1 != root))
    {pre_l, pre_r} = Enum.split(pre_nodes, length(in_l))
    {do_build_tree(pre_l, in_l), root, do_build_tree(pre_r, in_r)}
  end
end
