defmodule Day3Test do
  use ExUnit.Case

  describe "day 3" do
    @describetag day: 3

    test "scan memory" do
      clean_sum =
        "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
        |> Day3.clean_mul_sum()

      assert clean_sum == 161
    end

    test "scan memory with condiitionals" do
      accurate_sum =
        "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
        |> Day3.accurate_mul_sum()

      assert accurate_sum == 48
    end
  end
end
