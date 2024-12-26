defmodule Mix.Tasks.Aoc.Solve do
  use Mix.Task

  @inputs "./inputs/day"

  @shortdoc "Runs the input from Advent of code for day: --day"
  @impl Mix.Task
  def run(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: [day: :integer])
    do_run(parsed)
  end

  defp do_run(day: 1) do
    lists =
      "#{@inputs}/1/input"
      |> File.stream!()
      |> Stream.map(&line_to_numbers/1)
      |> Enum.to_list()
      |> Enum.unzip()

    distance = Day1.total_distance(lists)
    IO.puts("The distance is #{distance}")
    similarity = Day1.similarity_score(lists)
    IO.puts("The simliarity score is #{similarity}")
  end

  defp line_to_numbers(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
