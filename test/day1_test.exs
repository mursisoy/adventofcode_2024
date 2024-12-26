defmodule Day1Test do
  use ExUnit.Case

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

  describe "day 1" do
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
end
