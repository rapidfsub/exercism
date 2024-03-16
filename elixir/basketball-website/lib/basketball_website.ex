defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    path
    |> parse_path!()
    |> Enum.reduce_while(data, fn key, data ->
      case data[key] do
        nil -> {:halt, nil}
        value -> {:cont, value}
      end
    end)
  end

  defp parse_path!(path) when is_binary(path) do
    path |> String.split(".")
  end

  def get_in_path(data, path) do
    parsed_path = path |> parse_path!()
    data |> get_in(parsed_path)
  end
end
