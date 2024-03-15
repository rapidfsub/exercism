defmodule LanguageList do
  def new() do
    []
  end

  def add(list, language) do
    list |> List.insert_at(0, language)
  end

  def remove(list) do
    list |> List.pop_at(0) |> elem(1)
  end

  def first(list) do
    list |> List.first()
  end

  def count(list) do
    list |> length()
  end

  def functional_list?(list) do
    list |> Enum.member?("Elixir")
  end
end
