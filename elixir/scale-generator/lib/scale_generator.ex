defmodule ScaleGenerator do
  @doc """
  Find the note for a given interval (`step`) in a `scale` after the `tonic`.

  "m": one semitone
  "M": two semitones (full tone)
  "A": augmented second (three semitones)

  Given the `tonic` "D" in the `scale` (C C# D D# E F F# G G# A A# B C), you
  should return the following notes for the given `step`:

  "m": D#
  "M": E
  "A": F
  """
  @spec step(scale :: list(String.t()), tonic :: String.t(), step :: String.t()) :: String.t()
  def step(scale, tonic, step) do
    scale
    |> Enum.concat(scale)
    |> Enum.drop_while(&(&1 != tonic))
    |> Enum.drop(step_size(step))
    |> hd()
  end

  defp step_size("m"), do: 1
  defp step_size("M"), do: 2
  defp step_size("A"), do: 3

  @doc """
  The chromatic scale is a musical scale with thirteen pitches, each a semitone
  (half-tone) above or below another.

  Notes with a sharp (#) are a semitone higher than the note below them, where
  the next letter note is a full tone except in the case of B and E, which have
  no sharps.

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C C# D D# E F F# G G# A A# B C)
  """
  @spec chromatic_scale(tonic :: String.t()) :: list(String.t())
  def chromatic_scale(tonic \\ "C") do
    chromatic_scale(tonic, &next_tone/1)
  end

  defp next_tone("C"), do: "C#"
  defp next_tone("C#"), do: "D"
  defp next_tone("D"), do: "D#"
  defp next_tone("D#"), do: "E"
  defp next_tone("E"), do: "F"
  defp next_tone("F"), do: "F#"
  defp next_tone("F#"), do: "G"
  defp next_tone("G"), do: "G#"
  defp next_tone("G#"), do: "A"
  defp next_tone("A"), do: "A#"
  defp next_tone("A#"), do: "B"
  defp next_tone("B"), do: "C"

  defp chromatic_scale(tonic, fun) do
    tonic
    |> upcase_tone()
    |> Stream.unfold(&{&1, fun.(&1)})
    |> Enum.take(13)
  end

  defp upcase_tone(<<t::binary-size(1)>>), do: String.upcase(t)
  defp upcase_tone(<<t::binary-size(1), a::binary-size(1)>>), do: String.upcase(t) <> a

  @doc """
  Sharp notes can also be considered the flat (b) note of the tone above them,
  so the notes can also be represented as:

  A Bb B C Db D Eb E F Gb G Ab

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C Db D Eb E F Gb G Ab A Bb B C)
  """
  @spec flat_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def flat_chromatic_scale(tonic \\ "C") do
    chromatic_scale(tonic, &flat_next_tone/1)
  end

  defp flat_next_tone("C"), do: "Db"
  defp flat_next_tone("Db"), do: "D"
  defp flat_next_tone("D"), do: "Eb"
  defp flat_next_tone("Eb"), do: "E"
  defp flat_next_tone("E"), do: "F"
  defp flat_next_tone("F"), do: "Gb"
  defp flat_next_tone("Gb"), do: "G"
  defp flat_next_tone("G"), do: "Ab"
  defp flat_next_tone("Ab"), do: "A"
  defp flat_next_tone("A"), do: "Bb"
  defp flat_next_tone("Bb"), do: "B"
  defp flat_next_tone("B"), do: "C"

  @doc """
  Certain scales will require the use of the flat version, depending on the
  `tonic` (key) that begins them, which is C in the above examples.

  For any of the following tonics, use the flat chromatic scale:

  F Bb Eb Ab Db Gb d g c f bb eb

  For all others, use the regular chromatic scale.
  """
  @flat_keys ~w[F Bb Eb Ab Db Gb Cb d g c f bb eb ab]
  @spec find_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def find_chromatic_scale(tonic) do
    if tonic in @flat_keys do
      flat_chromatic_scale(tonic)
    else
      chromatic_scale(tonic)
    end
  end

  @doc """
  The `pattern` string will let you know how many steps to make for the next
  note in the scale.

  For example, a C Major scale will receive the pattern "MMmMMMm", which
  indicates you will start with C, make a full step over C# to D, another over
  D# to E, then a semitone, stepping from E to F (again, E has no sharp). You
  can follow the rest of the pattern to get:

  C D E F G A B C
  """
  @spec scale(tonic :: String.t(), pattern :: String.t()) :: list(String.t())
  def scale(tonic, pattern) do
    [tonic | _] = scale = find_chromatic_scale(tonic)
    [tonic | String.graphemes(pattern) |> Enum.scan(tonic, &step(scale, &2, &1))]
  end
end
