defmodule FileSniffer do
  def type_from_extension("exe"), do: "application/octet-stream"
  def type_from_extension("bmp"), do: "image/bmp"
  def type_from_extension("png"), do: "image/png"
  def type_from_extension("jpg"), do: "image/jpg"
  def type_from_extension("gif"), do: "image/gif"
  def type_from_extension(_extension), do: nil

  def type_from_binary(<<0x7F45_4C46::32, _::binary>>), do: "application/octet-stream"
  def type_from_binary(<<0x424D::16, _::binary>>), do: "image/bmp"
  def type_from_binary(<<0x8950_4E47_0D0A_1A0A::64, _::binary>>), do: "image/png"
  def type_from_binary(<<0xFFD8_FF::24, _::binary>>), do: "image/jpg"
  def type_from_binary(<<0x4749_46::24, _::binary>>), do: "image/gif"
  def type_from_binary(_file_binary), do: nil

  def verify(file_binary, extension) do
    with type when not is_nil(type) <- extension |> type_from_extension(),
         ^type <- file_binary |> type_from_binary() do
      {:ok, type}
    else
      _ -> {:error, "Warning, file format and file extension do not match."}
    end
  end
end
