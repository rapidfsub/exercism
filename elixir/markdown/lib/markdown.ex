defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m
    |> String.split("\n")
    |> Enum.map(&process/1)
    |> Enum.join()
    |> patch()
  end

  defp process(t) do
    cond do
      t =~ ~r/^\#{1,6}[^#]/ -> parse_header_md(t)
      t =~ ~r/^\*/ -> parse_list_md(t)
      true -> parse_paragraph_tag(t)
    end
  end

  defp parse_header_md(hwt) do
    [h | t] = String.split(hwt)
    Enum.join(t, " ") |> enclose("h#{String.length(h)}")
  end

  defp parse_list_md(l) do
    l
    |> String.trim_leading("* ")
    |> String.split()
    |> join_words_with_tags()
    |> enclose("li")
  end

  defp parse_paragraph_tag(t) do
    t
    |> String.split()
    |> join_words_with_tags()
    |> enclose("p")
  end

  defp enclose(text, name) do
    get_start_tag(name) <> text <> get_end_tag(name)
  end

  defp get_start_tag(name) do
    "<" <> name <> ">"
  end

  defp get_end_tag(name) do
    "</" <> name <> ">"
  end

  defp join_words_with_tags(t) do
    Enum.map(t, &replace_md_with_tag/1) |> Enum.join(" ")
  end

  defp replace_md_with_tag(w) do
    w
    |> maybe_replace(~r/^_{2}/, get_start_tag("strong"))
    |> maybe_replace(~r/^_{1}/, get_start_tag("em"))
    |> maybe_replace(~r/_{2}$/, get_end_tag("strong"))
    |> maybe_replace(~r/_{1}$/, get_end_tag("em"))
  end

  defp maybe_replace(w, pattern, replacement) do
    if w =~ pattern do
      String.replace(w, pattern, replacement)
    else
      w
    end
  end

  defp patch(l) do
    String.replace(l, ~r/(<li>.+<\/li>)/, &enclose(&1, "ul"))
  end
end
