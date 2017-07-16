defmodule GameoflifeTest do
  use ExUnit.Case
  doctest GameOfLife

  def game_has_cells(game, cells) do
    Enum.all?(cells, fn cell -> GameOfLife.cell_is_alive?(game, cell) end)
      && Enum.count(game.board) == Enum.count(cells)
  end

  test "a board is empty by default" do
    assert GameOfLife.cell_count(GameOfLife.new_game) == 0
  end

  test "a board can be created with cells" do
    game = GameOfLife.new_game([%{x: 1, y: 0}])
    assert GameOfLife.cell_count(game) == 1
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

  test "a cell should die if it has <2 neighbours" do
    cell_that_should_die = %{x: 0, y: 0}
    game = GameOfLife.new_game([
      cell_that_should_die,
      %{x: 1, y: 0},
    ])

    assert GameOfLife.cell_should_die?(game, cell_that_should_die)
  end

  test "a cell should die if it has >3 neighbours" do
    cell_that_should_die = %{x: 0, y: 0}
    game = GameOfLife.new_game([
      cell_that_should_die,
      %{x: 1, y: 0},
      %{x: 1, y: 1},
      %{x: 0, y: 1},
      %{x: 0, y: -1},
    ])

    assert GameOfLife.cell_should_die?(game, cell_that_should_die)
  end

  test "a cell should come alive if it has 3 neighbours" do
    cell_that_should_come_alive = %{x: 0, y: 0}
    game = GameOfLife.new_game([
      %{x: 1, y: 0},
      %{x: 1, y: 1},
      %{x: 0, y: 1},
    ])

    assert GameOfLife.cell_should_come_alive?(game, cell_that_should_come_alive)
  end

  test "a cell should not come alive if it has >3 neighbours" do
    cell_that_should_come_alive = %{x: 0, y: 0}
    game = GameOfLife.new_game([
      %{x: 1, y: 0},
      %{x: 1, y: 1},
      %{x: 0, y: 1},
      %{x: 0, y: -1},
    ])

    refute GameOfLife.cell_should_come_alive?(game, cell_that_should_come_alive)
  end

  test "an already existing cell should not come alive" do
    cell_that_is_alive = %{x: 0, y: 0}
    game = GameOfLife.new_game([
      cell_that_is_alive,
      %{x: 1, y: 0},
      %{x: 1, y: 1},
      %{x: 0, y: 1},
    ])

    refute GameOfLife.cell_should_come_alive?(game, cell_that_is_alive)
  end

  test "ticking with the blinker" do
    original_cells = [
      %{x: -1, y: 0},
      %{x: 0, y: 0},
      %{x: 1, y: 0},
    ]

    game = GameOfLife.new_game(original_cells)

    new_game = GameOfLife.tick(game)

    assert new_game.board == [
      %{x: 0, y: 0},
      %{x: 0, y: -1},
      %{x: 0, y: 1},
    ]

    final_game = GameOfLife.tick(new_game)
    assert game_has_cells(final_game, original_cells)
  end

  test "when the game ticks it updates the count" do
    original_cells = [
      %{x: -1, y: 0},
      %{x: 0, y: 0},
      %{x: 1, y: 0},
    ]
    game = GameOfLife.new_game(original_cells)
    final_game = game |> GameOfLife.tick |> GameOfLife.tick |> GameOfLife.tick
    assert final_game.ticks == 3

  end
end
