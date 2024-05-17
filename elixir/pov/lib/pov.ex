defmodule Pov do
  @typedoc """
  A tree, which is made of a node with several branches
  """
  @type tree :: {any, [tree]}

  @doc """
  Reparent a tree on a selected node.
  """
  @spec from_pov(tree :: tree, node :: any) :: {:ok, tree} | {:error, atom}
  def from_pov(tree, node) do
    case get_path(tree, node, []) do
      nil -> {:error, :nonexistent_target}
      path -> {:ok, reparent(path)}
    end
  end

  defp get_path({node, _leaves} = tree, node, did_visit), do: [tree | did_visit]
  defp get_path({_value, []}, _node, _did_visit), do: nil

  defp get_path({_value, leaves} = tree, node, did_visit) do
    did_visit = [tree | did_visit]
    Enum.find_value(leaves, &get_path(&1, node, did_visit))
  end

  defp reparent([head]) do
    head
  end

  defp reparent([{child_value, child_leaves} | tail]) do
    {parent_value, parent_leaves} = reparent(tail)
    {[_], parent_leaves} = Enum.split_with(parent_leaves, &(elem(&1, 0) == child_value))
    {child_value, [{parent_value, parent_leaves} | child_leaves]}
  end

  @doc """
  Finds a path between two nodes
  """
  @spec path_between(tree :: tree, from :: any, to :: any) :: {:ok, [any]} | {:error, atom}
  def path_between(tree, from, to) do
    case from_pov(tree, to) do
      {:ok, tree} ->
        case get_path(tree, from, []) do
          nil -> {:error, :nonexistent_source}
          path -> {:ok, Enum.map(path, &elem(&1, 0))}
        end

      {:error, _reason} ->
        {:error, :nonexistent_destination}
    end
  end
end
