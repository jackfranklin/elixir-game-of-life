defmodule GameoflifeTest do
  use ExUnit.Case
  doctest GameOfLife

  test "a board is empty by default" do
    %{ board: board } = GameOfLife.new_game
    assert (length board) == 0
  end

  test "a board can be created with cells" do
    %{ board: board } = GameOfLife.new_game ([%{x: 1, y: 0}])
    assert (length board) == 1
  end

  test "it can tell if two cells are next to each other" do
    cell1 = %{x: 1, y: 0}
    cell2 = %{x: 1, y: 1}
    assert GameOfLife.neighbours?(cell1, cell2)
  end

  test "it can tell when two cells are not next to each other" do
    cell1 = %{x: 1, y: 0}
    cell2 = %{x: 3, y: 1}
    refute GameOfLife.neighbours?(cell1, cell2)
  end

  test "it can get the list of neighbouring cells" do
    cell = %{x: 0, y: 0}
    expected = [
      %{x: -1, y: -1},
      %{x: -1, y: 0},
      %{x: -1, y: 1},
      %{x: 0, y: -1},
      %{x: 0, y: 1},
      %{x: 1, y: -1},
      %{x: 1, y: 0},
      %{x: 1, y: 1},
    ]

    assert GameOfLife.potential_neighbours_for_cell(cell) == expected
  end

  test "it can filter a list of cells to find the neighbouring cells" do
    cell = %{x: 0, y: 0}
    game = GameOfLife.new_game([
      cell,
      %{x: 3, y: 1},
      %{x: 1, y: 0},
      %{x: 2, y: -2},
    ])

    assert GameOfLife.neighbours_of_cell(game, cell) == [
      %{x: 1, y: 0},
    ]

  end
end
