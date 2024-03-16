defmodule Username do
  def sanitize(username) do
    username |> Enum.flat_map(&do_sanitize/1)
  end

  defp do_sanitize(letter) do
    case letter do
      letter when letter in ?a..?z -> [letter]
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
      ?_ -> ~c"_"
      _letter -> ~c""
    end
  end
end
