defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  defp day1(_context) do
    [
      input:
        """
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3\
        """
        |> String.split("\n")
    ]
  end

  describe "Tests for day 1: " do
    @describetag day: 1
    setup [:day1]

    test "calc total distance", %{input: input} do
      total_distance =
        input
        |> Day1.lists_from_input_stream()
        |> Day1.total_distance()

      assert total_distance == 11
    end

    test "calc similarity score", %{input: input} do
      similarity_score =
        input
        |> Day1.lists_from_input_stream()
        |> Day1.similarity_score()

      assert similarity_score == 31
    end
  end

  defp day2(_context) do
    [
      input:
        """
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9\
        """
        |> String.split("\n")
    ]
  end

  describe "Tests for day 2: " do
    @describetag day: 2
    setup [:day2]

    test "count safe reports", %{input: input} do
      safe_reports =
        input
        |> Day2.reports_from_input_stream()
        |> Day2.count_safe_reports()

      assert safe_reports == 2
    end

    test "count dampened safe reports", %{input: input} do
      dampened_safe_reports =
        input
        |> Day2.reports_from_input_stream()
        |> Day2.count_safe_reports(with_dampener: true)

      assert dampened_safe_reports == 4
    end
  end
end
