defmodule Day2Test do
  use ExUnit.Case

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

  describe "day 2" do
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
