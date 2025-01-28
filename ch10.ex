defmodule Square do
  alias __MODULE__
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_size 1..8

  def new(col, row) when col in 1..3 and row in 1..3 do
    {:ok, %Square{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_square}

  def new_board do
    for s <- squares(), into: %{}, do: {s, :empty}
  end

  def squares do
    for c <- @board_size, r <- @board_size, into: MapSet.new(), do: %Square{col: c, row: r}
  end

  def rook_attacks(board, col, row) do
    for {%{col: c, row: r}, _} = s <- board, :erlang.xor(col == c, row == r), do: s
  end

  def bishop_attacks(board, col, row) do
    for {%{col: c, row: r}, _} = s <- board,
        :erlang.xor(c - r == col - row, c + r == col + row),
        do: s
  end

  def knight_attacks(board, col, row) do
    for {%{col: c, row: r}, _} = s <- board,
        (abs(c - col) == 2 and abs(r - row) == 1) or
          (abs(c - col) == 1 and abs(r - row) == 2),
        do: s
  end
end
