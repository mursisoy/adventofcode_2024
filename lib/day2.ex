defmodule Day2 do
  @moduledoc """
  Solves: https://adventofcode.com/2024/day/2

  A report only counts as safe if both of the following are true:

    The levels are either all increasing or all decreasing.
    Any two adjacent levels differ by at least one and at most three.
  """

  import AdventOfCode

  defguard is_safe_differ(a, b) when abs(a - b) <= 3 and abs(a - b) >= 1

  defguard is_same_sign(diff, sign) when abs(diff) > 0 and diff / abs(diff) == sign

  @spec reports_from_input_stream(Enumerable.t(String.t())) :: Enumerable.t([integer()])
  @doc """
  Returns reports as lists of integers from string inputs
  """
  def reports_from_input_stream(input) do
    input
    |> Stream.map(&line_to_numbers/1)
  end

  def count_safe_reports(reports, opts \\ [with_dampener: false])

  def count_safe_reports(reports, with_dampener: false) do
    reports
    |> Stream.filter(&safe_report?/1)
    |> Enum.count()
  end

  def count_safe_reports(reports, with_dampener: true) do
    reports
    |> Stream.filter(&dampened_safe_report?/1)
    |> Enum.count()
  end

  # Create a list with all possible dampened results as stream
  # Then drops reports til found a safe one or til the end
  # Returns wheter there are any safe report or not
  defp dampened_safe_report?(report) do
    [report]
    |> Stream.concat(build_dampened_reports(report))
    |> Stream.drop_while(&(!safe_report?(&1)))
    |> Enum.empty?()
    |> Kernel.not()
  end

  # Builds a list of reports deleting one item for each entry
  defp build_dampened_reports(report) do
    report
    |> Stream.duplicate(length(report))
    |> Stream.with_index()
    |> Stream.map(fn {x, i} -> List.delete_at(x, i) end)
  end

  # This function will iterate through a list, checking defined guard conditions til end.
  # When conditions are not met, returns false.
  defp safe_report?([a | [b | t]]) when is_safe_differ(a, b),
    do: safe_report?(t, prev: b, sign: (b - a) / abs(b - a))

  defp safe_report?(_), do: false

  defp safe_report?([], _), do: true

  defp safe_report?([h | t], prev: prev, sign: sign)
       when is_safe_differ(h, prev) and is_same_sign(h - prev, sign),
       do: safe_report?(t, prev: h, sign: sign)

  defp safe_report?(_, _), do: false
end
