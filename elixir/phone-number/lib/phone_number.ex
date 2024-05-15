defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    text = String.replace(raw, ~r/[.+\-\(\)\s]/, "")

    case Regex.run(~r/^(\d?)(\d{3})(\d{3})(\d{4})$/, text) do
      [_, country, area, exchange, subscriber] ->
        cond do
          country not in ["", "1"] -> {:error, "11 digits must start with 1"}
          String.starts_with?(area, "0") -> {:error, "area code cannot start with zero"}
          String.starts_with?(area, "1") -> {:error, "area code cannot start with one"}
          String.starts_with?(exchange, "0") -> {:error, "exchange code cannot start with zero"}
          String.starts_with?(exchange, "1") -> {:error, "exchange code cannot start with one"}
          true -> {:ok, area <> exchange <> subscriber}
        end

      nil ->
        cond do
          String.match?(text, ~r/\D/) -> {:error, "must contain digits only"}
          String.length(text) < 10 -> {:error, "must not be fewer than 10 digits"}
          String.length(text) > 11 -> {:error, "must not be greater than 11 digits"}
        end
    end
  end
end
