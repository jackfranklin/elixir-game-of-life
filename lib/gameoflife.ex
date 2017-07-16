defmodule GameOfLife do
  @moduledoc """
  Documentation for Gameoflife.
  """

  def new_game(cells \\ []) do
    %{board: cells}
  end

  def neighbours?(%{x: x1, y: y1} = cell1, %{x: x2, y: y2} = cell2) do
    abs(x1 - x2) <= 1 && abs(y1 - y2) <= 1 && !cells_equal?(cell1, cell2)
  end

  def potential_neighbours_for_cell(cell) do
    cell
    |> generate_grid
    |> Enum.filter(fn neighbour -> cells_equal?(cell, neighbour) == false end)
  end

  def neighbours_of_cell(%{board: board}, cell) do
    # board |> Enum.filter(fn board_cell
    []
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
