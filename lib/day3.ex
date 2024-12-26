defmodule Day3 do
  @moduledoc """
  --- Day 3: Mull It Over ---

  Solves: https://adventofcode.com/2024/day/3
  """

  @spec clean_mul_sum(binary()) :: number()
  def clean_mul_sum(memory) do
    ~r/mul\((?<first>\d{1,3}),(?<second>\d{1,3})\)/
    |> Regex.scan(memory, capture: ["first", "second"])
    |> Enum.map(&do_mul/1)
    |> Enum.sum()
  end

  @spec accurate_mul_sum(binary()) :: number()
  def accurate_mul_sum(memory) do
    ~r/((do\(\))|(don't\(\)))/
    |> Regex.split(memory, include_captures: true)
    |> then(&["do()" | &1])
    |> Enum.chunk_every(2)
    |> Enum.reduce(
      0,
      fn
        ["do()", mem], acc -> acc + clean_mul_sum(mem)
        ["don't()", _], acc -> acc
      end
    )
  end

  defp do_mul([first, second]) do
    String.to_integer(first) * String.to_integer(second)
  end
end
