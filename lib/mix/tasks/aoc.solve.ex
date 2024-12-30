defmodule Mix.Tasks.Aoc.Solve do
  @moduledoc """
  Mix task to solve Advent of Code inputs
  """
  use Mix.Task

  import AdventOfCode

  @shortdoc "Runs the input from Advent of code for day: --day"
  @impl Mix.Task
  def run(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: [day: :integer])
    do_run(parsed)
  end

  @spec do_run([{:day, non_neg_integer()}]) :: :ok
  defp do_run(day: day) when day == 1 do
    lists =
      day
      |> input_file_stream()
      |> Day1.lists_from_input_stream()

    distance = Day1.total_distance(lists)
    IO.puts("The distance is #{distance}")
    similarity = Day1.similarity_score(lists)
    IO.puts("The simliarity score is #{similarity}")
  end

  defp do_run(day: day) when day == 2 do
    reports =
      day
      |> input_file_stream()
      |> Day2.reports_from_input_stream()

    count =
      reports
      |> Day2.count_safe_reports()

    IO.puts("Safe reports: #{count}")

    count =
      reports
      |> Day2.count_safe_reports(with_dampener: true)

    IO.puts("Dampened safe reports: #{count}")
  end

  defp do_run(day: day) when day == 3 do
    sum =
      day
      |> input_file_read!()
      |> Day3.clean_mul_sum()

    IO.puts("The sum is #{sum}")

    accurate_sum =
      day
      |> input_file_read!()
      |> Day3.accurate_mul_sum()

    IO.puts("The accurate sum is #{accurate_sum}")
  end

  defp do_run(day: day) when day == 4 do
    input =
      day
      |> input_file_stream()

    input
    |> Day4.search_word("XMAS")
    |> then(&IO.puts("XMAS Count: #{&1}"))

    input
    |> Day4.search_cross_word("MAS")
    |> then(&IO.puts("X-MAS Count: #{&1}"))
  end

  defp do_run(day: day) when day == 5 do
    {rules, updates} =
      day
      |> input_file_read!()
      |> Day5.parse()

    sum_updates =
      updates
      |> Stream.filter(&Day5.update_correct?(&1, rules))
      |> Day5.sum_middle_pages()

    IO.puts("Correct middle page sum: #{sum_updates}")

    sum_fixed_updates =
      updates
      |> Stream.reject(&Day5.update_correct?(&1, rules))
      |> Stream.map(&Day5.maybe_fix_update(&1, rules))
      |> Day5.sum_middle_pages()

    IO.puts("Fixed middle page sum: #{sum_fixed_updates}")
  end

  defp do_run(day: day) when day == 6 do
    {_, %Day6{path: path}} =
      day
      |> input_file_stream()
      |> Day6.init(130)
      |> Day6.calculate_guard_route()

    IO.puts("Guard positions: #{Day6.count_positions(path)}")

    loop_obstructions =
      day
      |> input_file_stream()
      |> Day6.init(130)
      |> Day6.find_loop_obstructions()
      |> length()

    IO.puts("Loop obstructions: #{loop_obstructions}")
  end
end
