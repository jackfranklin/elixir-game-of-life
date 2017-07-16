defmodule GameOfLife do
  @moduledoc """
  Documentation for Gameoflife.
  """

  def new_game(cells \\ [], ticks \\ 0) do
    %{board: cells, ticks: ticks}
  end

  def tick(game) do
    cells_that_live = kill_living_cells(game)
    new_cells = get_new_cells(game)
    new_game(Enum.concat(cells_that_live, new_cells), game.ticks + 1)
  end

  def kill_living_cells(game) do
    Enum.filter(game.board, &(cell_should_die?(game, &1) == false))
  end

  def neighbours?(%{x: x1, y: y1} = cell1, %{x: x2, y: y2} = cell2) do
    abs(x1 - x2) <= 1 && abs(y1 - y2) <= 1 && !cells_equal?(cell1, cell2)
  end

  defp get_new_cells(game) do
    game.board
    |> Enum.flat_map(&potential_neighbours_for_cell/1)
    |> Enum.filter(&(cell_should_come_alive?(game, &1)))
    |> Enum.uniq
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
    |> Enum.filter(&(Enum.member?(potential_neighbours, &1)))
  end


  def cell_count(game) do
    Enum.count(game.board)
  end

  def cell_should_die?(game, cell) do
    neighbour_count = neighbour_count_for_cell(game, cell)
    case neighbour_count do
      2 -> false
      3 -> false
      _ -> true
    end
  end

  def neighbour_count_for_cell(game, cell) do
    Enum.count(neighbours_of_cell(game, cell))
  end

  def cell_should_come_alive?(game, cell) do
    neighbour_count = neighbour_count_for_cell(game, cell)
    neighbour_count == 3 && cell_is_alive?(game, cell) == false
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
    |> Enum.flat_map(fn x_val -> Enum.map(y_range, fn y_val -> %{x: x_val, y: y_val} end) end)
    |> Enum.to_list
  end
end
