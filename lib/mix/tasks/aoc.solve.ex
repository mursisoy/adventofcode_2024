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
end
