defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    files
    |> Enum.flat_map(fn file ->
      lines =
        file
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Stream.with_index(1)
        |> Stream.filter(fn {line, _num} ->
          {line, pattern} =
            if "-i" in flags do
              {line |> String.downcase(), pattern |> String.downcase()}
            else
              {line, pattern}
            end

          predicate =
            if "-x" in flags do
              line == pattern
            else
              line |> String.contains?(pattern)
            end

          if "-v" in flags do
            not predicate
          else
            predicate
          end
        end)
        |> Stream.map(fn {line, num} ->
          if "-n" in flags do
            "#{num}:#{line}"
          else
            line
          end
        end)
        |> Stream.map(fn line ->
          case files do
            [_, _ | _] -> "#{file}:#{line}"
            _ -> line
          end
        end)

      if "-l" in flags and not Enum.empty?(lines) do
        [file]
      else
        lines
      end
      |> Enum.map(&(&1 <> "\n"))
    end)
    |> to_string()
  end
end
