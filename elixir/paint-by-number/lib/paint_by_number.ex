defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    do_palette_bit_size(color_count, 1)
  end

  defp do_palette_bit_size(color_count, exp) do
    if Integer.pow(2, exp) < color_count do
      do_palette_bit_size(color_count, exp + 1)
    else
      exp
    end
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2, 1::2, 2::2, 3::2>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    n = palette_bit_size(color_count)
    <<pixel_color_index::size(n), picture::bitstring>>
  end

  def get_first_pixel(picture, color_count) do
    picture |> split_first_pixel(color_count) |> elem(0)
  end

  defp split_first_pixel(<<>>, _color_count) do
    {nil, <<>>}
  end

  defp split_first_pixel(picture, color_count) do
    n = palette_bit_size(color_count)
    <<first::size(n), rest::bitstring>> = picture
    {first, rest}
  end

  def drop_first_pixel(picture, color_count) do
    picture |> split_first_pixel(color_count) |> elem(1)
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
