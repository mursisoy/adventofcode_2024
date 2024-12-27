defmodule Day4Test do
  use ExUnit.Case

  describe "day 4" do
    @describetag day: 4

    test "search XMAS" do
      text =
        """
        ..X...
        .SAMX.
        .A..A.
        XMAS.S
        .X....\
        """
        |> String.split("\n")

      assert Day4.search_word(text, "XMAS") == 4
    end

    test "search cross MAS" do
      text =
        """
        .M.S......
        ..A..MSMS.
        .M.S.MAA..
        ..A.ASMSM.
        .M.S.M....
        ..........
        S.S.S.S.S.
        .A.A.A.A..
        M.M.M.M.M.
        ..........\
        """
        |> String.split("\n")

      assert Day4.search_cross_word(text, "MAS") == 9
    end
  end
end
