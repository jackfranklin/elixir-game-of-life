defmodule GameOfLife do
  @moduledoc """
  Documentation for Gameoflife.
  """

  def new_game(cells \\ []) do
    %{board: cells}
  end

  def tick(game) do
    cells_that_live = Enum.filter(game.board, fn cell -> cell_should_die?(game, cell) == false end)
    new_cells = get_new_cells(game)
    %{board: Enum.concat(cells_that_live, new_cells)}
  end

  def neighbours?(%{x: x1, y: y1} = cell1, %{x: x2, y: y2} = cell2) do
    abs(x1 - x2) <= 1 && abs(y1 - y2) <= 1 && !cells_equal?(cell1, cell2)
  end

  defp get_new_cells(game) do
    game.board
    |> Enum.flat_map(fn cell -> potential_neighbours_for_cell(cell) end)
    |> Enum.uniq
    |> Enum.filter(fn cell -> cell_should_come_alive?(game, cell) end)
  end

  def potential_neighbours_for_cell(cell) do
    cell
    |> generate_grid
    |> Enum.filter(fn neighbour -> cells_equal?(cell, neighbour) == false end)
  end

  def neighbours_of_cell(%{board: board}, cell) do
    potential_neighbours = potential_neighbours_for_cell(cell)
    board
    |> Enum.filter(fn board_cell -> cells_equal?(cell, board_cell) == false end)
    |> Enum.filter(fn board_cell -> Enum.member?(potential_neighbours, board_cell) end)
  end


  def cell_count(game) do
    Enum.count(game.board)
  end

  def cell_should_die?(game, cell) do
    neighbours = neighbours_of_cell(game, cell)
    Enum.count(neighbours) < 2 || Enum.count(neighbours) > 3
  end

  def cell_should_come_alive?(game, cell) do
    neighbours = neighbours_of_cell(game, cell)
    Enum.count(neighbours) == 3 && cell_is_alive?(game, cell) == false
  end

  def cell_is_alive?(game, cell) do
    Enum.member?(game.board, cell)
  end

  defp cells_equal?(cell1, cell2) do
    cell1.x == cell2.x && cell1.y == cell2.y
  end

  defp generate_grid(cell) do
    generate_grid(cell.x, cell.y)
  end

  defp generate_grid(x, y) do
    y_range = (y - 1)..(y + 1)
    (x - 1)..(x + 1)
    |> Enum.flat_map(fn x_val -> Enum.map(y_range, make_coordinate_with_x(x_val)) end)
    |> Enum.to_list
  end

  defp make_coordinate_with_x(x) do
    fn y -> %{x: x, y: y} end
  end
end
