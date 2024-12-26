defmodule Mix.Tasks.Aoc.Download do
  use Mix.Task

  @input_url "https://adventofcode.com/2024/day"
  @inputs_dir Application.compile_env(:advent_of_code, :inputs_dir, "./inputs/day")

  @shortdoc "Runs the input from Advent of code for day: --day"
  @impl Mix.Task
  def run(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: [day: :integer])
    do_download_input(parsed)
  end

  def do_download_input(day: day) do
    session = Application.get_env(:advent_of_code, :session, "")
    HTTPoison.start()

    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: body
     }} =
      HTTPoison.get(
        "#{@input_url}/#{day}/input",
        [{"Cookie", "session=#{session}"}]
      )

    input_file = "#{@inputs_dir}/#{day}/input"

    File.write!(input_file, body)

    IO.puts("Input for day #{day} downloaded in #{input_file}")
  end
end
