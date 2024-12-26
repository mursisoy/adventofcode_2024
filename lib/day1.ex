defmodule Day1 do
  @moduledoc """
  Solves: https://adventofcode.com/2024/day/1
  """

  import AdventOfCode

  @spec lists_from_input_stream(Enumerable.t()) :: {list(), list()}
  @doc """
  Parses a stream of two columns of numbers into two lists
  """
  def lists_from_input_stream(input) do
    input
    |> Stream.map(&line_to_numbers/1)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.to_list()
    |> Enum.unzip()
  end

  @spec total_distance({[non_neg_integer()], [non_neg_integer()]}) :: non_neg_integer()
  @doc """
  From two lists, sort them, zip them and calculate tuple absolute distances, then sum.
  """
  def total_distance({left, right}) do
    [Enum.sort(left), Enum.sort(right)]
    |> Enum.zip_with(fn [x, y] -> abs(x - y) end)
    |> Enum.sum()
  end

  @spec similarity_score({[non_neg_integer()], [non_neg_integer()]}) :: non_neg_integer()
  @doc """
  From two lists, get right frequencies and multiply the ocurrence from the left list with the frequency of itself in the second list
  """
  def similarity_score({left, right}) do
    freqs = Enum.frequencies(right)

    left
    |> Stream.map(fn x -> x * Map.get(freqs, x, 0) end)
    |> Enum.sum()
  end
end
