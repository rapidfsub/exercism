defmodule DNA do
  def encode_nucleotide(?\s), do: 0b0000
  def encode_nucleotide(?A), do: 0b0001
  def encode_nucleotide(?C), do: 0b0010
  def encode_nucleotide(?G), do: 0b0100
  def encode_nucleotide(?T), do: 0b1000

  def decode_nucleotide(0b0000), do: ?\s
  def decode_nucleotide(0b0001), do: ?A
  def decode_nucleotide(0b0010), do: ?C
  def decode_nucleotide(0b0100), do: ?G
  def decode_nucleotide(0b1000), do: ?T

  def encode(dna) do
    dna
    |> Enum.map(&encode_nucleotide/1)
    |> Enum.map(&<<&1::4>>)
    |> Enum.reduce(&<<&2::bitstring, &1::bitstring>>)
  end

  def decode(dna) do
    for <<code::4 <- dna>> do
      decode_nucleotide(code)
    end
  end
end
