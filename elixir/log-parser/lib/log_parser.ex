defmodule LogParser do
  def valid_line?(line) do
    line |> String.match?(~r/^\[(DEBUG|INFO|WARNING|ERROR)\]/)
  end

  def split_line(line) do
    line |> String.split(~r/<[~*=-]*>/)
  end

  def remove_artifacts(line) do
    line |> String.replace(~r/end-of-line\p{N}+/i, "")
  end

  def tag_with_user_name(line) do
    line |> String.replace(~r/\A(?:.|\n)*User\s+(\S+)(?:.|\n)*\z/m, "[USER] \\1 \\0")
  end
end
