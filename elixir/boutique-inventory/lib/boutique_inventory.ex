defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    inventory |> Enum.sort_by(& &1.price)
  end

  def with_missing_price(inventory) do
    inventory |> Enum.reject(& &1.price)
  end

  def update_names(inventory, old_word, new_word) do
    inventory
    |> Enum.map(fn item ->
      item |> Map.update!(:name, &String.replace(&1, old_word, new_word))
    end)
  end

  def increase_quantity(item, count) do
    item
    |> Map.update!(:quantity_by_size, fn quantities ->
      quantities |> Map.new(fn {size, quantity} -> {size, quantity + count} end)
    end)
  end

  def total_quantity(item) do
    item.quantity_by_size
    |> Map.values()
    |> Enum.reduce(0, &+/2)
  end
end
