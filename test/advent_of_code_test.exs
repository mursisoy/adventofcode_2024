defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  defp day1(_context) do
    [left: [3, 4, 2, 1, 3, 3], right: [4, 3, 5, 3, 9, 3]]
  end

  describe "Tests for day 1" do
    @describetag day: 1
    setup [:day1]

    test "calc total distance", %{left: left, right: right} do
      assert Day1.total_distance({left, right}) == 11
    end

    test "calc similarity score", %{left: left, right: right} do
      assert Day1.similarity_score({left, right}) == 31
    end
  end

end
