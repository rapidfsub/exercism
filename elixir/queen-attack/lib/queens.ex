defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []) do
    {black, opts} = opts |> Keyword.pop(:black)
    {white, opts} = opts |> Keyword.pop(:white)

    unless opts |> Enum.empty?() and black != white do
      raise ArgumentError
    end

    for {r, c} <- [black, white], r not in 0..7 or c not in 0..7 do
      raise ArgumentError
    end

    %__MODULE__{black: black, white: white}
  end

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%__MODULE__{black: black, white: white}) do
    0..7
    |> Enum.map_join("\n", fn r ->
      0..7
      |> Enum.map_join(" ", fn c ->
        case {r, c} do
          ^black -> "B"
          ^white -> "W"
          _ -> "_"
        end
      end)
    end)
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%__MODULE__{black: nil}), do: false
  def can_attack?(%__MODULE__{white: nil}), do: false
  def can_attack?(%__MODULE__{black: {r, _}, white: {r, _}}), do: true
  def can_attack?(%__MODULE__{black: {_, c}, white: {_, c}}), do: true
  def can_attack?(%__MODULE__{black: {r, c}, white: {c, r}}), do: true
  def can_attack?(%__MODULE__{black: {br, bc}, white: {wr, wc}}), do: abs(br - wr) == abs(bc - wc)
end
