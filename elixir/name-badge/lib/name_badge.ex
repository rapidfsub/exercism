defmodule NameBadge do
  def print(id, name, department) do
    department =
      if department do
        department
      else
        "owner"
      end
      |> String.upcase()

    if id do
      ["[#{id}]", name, department]
    else
      [name, department]
    end
    |> Enum.join(" - ")
  end
end
