defmodule Username do
  def sanitize(username) do
    username |> Enum.flat_map(&do_sanitize/1)
  end

  def do_sanitize(letter) when letter in ?a..?z, do: [letter]
  def do_sanitize(?ä), do: ~c"ae"
  def do_sanitize(?ö), do: ~c"oe"
  def do_sanitize(?ü), do: ~c"ue"
  def do_sanitize(?ß), do: ~c"ss"
  def do_sanitize(?_), do: [?_]
  def do_sanitize(_letter), do: []
end
