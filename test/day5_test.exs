defmodule Day5Test do
  use ExUnit.Case

  defp day5(_context) do
    [
      input: """
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47\
      """
    ]
  end

  describe "day 5" do
    @describetag day: 5
    setup [:day5]

    test "sum correct updated", %{input: input} do
      {rules, updates} = Day5.parse(input)

      sum_updates =
        updates
        |> Stream.filter(&Day5.update_correct?(&1, rules))
        |> Day5.sum_middle_pages()

      assert sum_updates == 143
    end

    test "sum fixed updates", %{input: input} do
      {rules, updates} = Day5.parse(input)

      sum_fixed_updates =
        updates
        |> Stream.reject(&Day5.update_correct?(&1, rules))
        |> Stream.map(&Day5.maybe_fix_update(&1, rules))
        |> Day5.sum_middle_pages()

      assert sum_fixed_updates == 123
    end
  end
end
