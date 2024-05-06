defmodule Ledger do
  defmodule Entry do
    @enforce_keys [:amount_in_cents, :date, :description]
    defstruct @enforce_keys

    def new(%{} = entry) do
      struct!(__MODULE__, entry)
    end

    def compare(%__MODULE__{} = lhs, %__MODULE__{} = rhs) do
      with :eq <- Date.compare(lhs.date, rhs.date),
           :eq <- do_compare(lhs.description, rhs.description),
           :eq <- do_compare(lhs.amount_in_cents, rhs.amount_in_cents) do
        :eq
      end
    end

    defp do_compare(lhs, rhs) when lhs < rhs, do: :lt
    defp do_compare(lhs, rhs) when lhs > rhs, do: :gt
    defp do_compare(_lhs, _rhs), do: :eq

    def format_entry(%__MODULE__{} = entry, currency, locale) do
      [
        Calendar.strftime(entry.date, date_format(locale)),
        format_description(entry.description),
        format_amount(entry.amount_in_cents, locale, currency)
      ]
      |> Enum.join(" | ")
    end

    defp date_format(:en_US), do: "%m/%d/%Y"
    defp date_format(_locale), do: "%d-%m-%Y"

    defp format_description(description) do
      if description |> String.length() > 26 do
        String.slice(description, 0, 22) <> "..."
      else
        String.pad_trailing(description, 25)
      end
    end

    defp format_amount(amount_in_cents, locale, currency) do
      amount_in_cents
      |> format_number(locale)
      |> do_format_amount(currency_unit(currency), locale, amount_in_cents >= 0)
      |> String.pad_leading(13)
    end

    defp do_format_amount(number, unit, :en_US, true), do: " #{unit}#{number} "
    defp do_format_amount(number, unit, :en_US, false), do: "(#{unit}#{number})"
    defp do_format_amount(number, unit, _locale, true), do: " #{unit} #{number} "
    defp do_format_amount(number, unit, _locale, false), do: " #{unit} -#{number} "

    defp format_number(number, :en_US), do: do_format_number(number, ",", ".")
    defp format_number(number, _locale), do: do_format_number(number, ".", ",")

    defp do_format_number(number, separator, decimal_point) do
      {decimal, whole} =
        number
        |> abs()
        |> Integer.digits()
        |> Enum.reverse()
        |> Enum.split(2)

      decimal = Enum.join(decimal) |> String.pad_trailing(2, "0")

      whole =
        whole
        |> Enum.chunk_every(3)
        |> Enum.map_join(separator, &Enum.join/1)
        |> String.pad_trailing(1, "0")

      String.reverse(decimal <> decimal_point <> whole)
    end

    defp currency_unit(:eur), do: "€"
    defp currency_unit(_currency), do: "$"
  end

  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @spec format_entries(currency(), locale(), list(entry())) :: String.t()
  def format_entries(currency, locale, entries) do
    entries
    |> Enum.map(&Entry.new/1)
    |> Enum.sort(Entry)
    |> Enum.map(&Entry.format_entry(&1, currency, locale))
    |> List.insert_at(0, get_header(locale))
    |> Enum.map_join(&(&1 <> "\n"))
  end

  defp get_header(:en_US), do: "Date       | Description               | Change       "
  defp get_header(_locale), do: "Datum      | Omschrijving              | Verandering  "
end
