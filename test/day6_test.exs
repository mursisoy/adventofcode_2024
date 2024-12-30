defmodule Day6Test do
  use ExUnit.Case

  defp day6(_context) do
    [
      input:
        """
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...\
        """
        |> String.split("\n")
    ]
  end

  describe "day 6" do
    @describetag day: 6
    setup [:day6]

    test "count guard positions", %{input: input} do
      {_, %Day6{path: path}} =
        input
        |> Day6.init(10)
        |> Day6.calculate_guard_route()

      assert Day6.count_positions(path) == 41
    end

    test "count loop obstructions", %{input: input} do
      loop_obstructions =
        input
        |> Day6.init(10)
        |> Day6.find_loop_obstructions()
        |> length()

      assert loop_obstructions == 6
    end
  end
end
