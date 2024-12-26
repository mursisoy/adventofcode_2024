defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  @inputs_dir Application.compile_env(:advent_of_code, :inputs_dir, "./inputs/day")


  def input_file_read!(day) do
    "#{@inputs_dir}/#{day}/input"
    |> File.read!()
  end
  def input_file_stream(day) do
    "#{@inputs_dir}/#{day}/input"
    |> File.stream!()
  end

  @spec line_to_numbers(String.t()) :: [integer()]
  def line_to_numbers(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
