defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> Enum.flat_map(&parse_match/1)
    |> Enum.reduce(%{}, fn {team, diff}, tally ->
      Map.update(tally, team, diff, fn acc ->
        Map.merge(acc, diff, fn _k, v1, v2 -> v1 + v2 end)
      end)
    end)
    |> Enum.sort(fn
      {team1, %{point: p}}, {team2, %{point: p}} -> team1 < team2
      {_team1, acc1}, {_team2, acc2} -> acc1.point > acc2.point
    end)
    |> Enum.map(fn {team, acc} ->
      format_row(team, [acc.match, acc.win, acc.draw, acc.lose, acc.point])
    end)
    |> List.insert_at(0, format_row("Team", ~w[MP W D L P]))
    |> Enum.join("\n")
  end

  defp parse_match(line) do
    String.split(line, ";") |> do_parse_match()
  end

  @win %{match: 1, win: 1, draw: 0, lose: 0, point: 3}
  @draw %{match: 1, win: 0, draw: 1, lose: 0, point: 1}
  @lose %{match: 1, win: 0, draw: 0, lose: 1, point: 0}
  defp do_parse_match([t1, t1, _wdl]), do: []
  defp do_parse_match([t1, t2, "win"]), do: [{t1, @win}, {t2, @lose}]
  defp do_parse_match([t1, t2, "draw"]), do: [{t1, @draw}, {t2, @draw}]
  defp do_parse_match([t1, t2, "loss"]), do: do_parse_match([t2, t1, "win"])
  defp do_parse_match(_invalid), do: []

  defp format_row(team, ps) do
    ps
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.pad_leading(&1, 2))
    |> List.insert_at(0, String.pad_trailing(team, 30))
    |> Enum.join(" | ")
  end
end
