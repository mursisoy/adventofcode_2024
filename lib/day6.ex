defmodule Day6 do
  @moduledoc """
  --- Day 6: Guard Gallivant ---

  Solves: https://adventofcode.com/2024/day/6
  """

  defstruct [:guard, :size, obstacles: %MapSet{}, path: %MapSet{}]

  @type guard_direction() :: :north | :east | :south | :west
  @type coordinate() :: {integer(), integer()}
  @type guard_position() :: {guard_direction(), coordinate()}
  @type guard_path() :: MapSet.t(guard_position())
  @type board_obstacles() :: MapSet.t(coordinate())

  @type t() :: %__MODULE__{
          guard: guard_position(),
          size: non_neg_integer(),
          obstacles: board_obstacles(),
          path: guard_path()
        }

  @doc """
  Initializes a Day6 struct with the information provided as an Enumerable of binaries.
  """
  @spec init(Enumerable.t(binary()), non_neg_integer()) :: Day6.t()
  def init(input, size) do
    {obstacles, guard_coord} =
      input
      |> Enum.with_index()
      |> Enum.flat_map(&parse_row/1)
      |> Enum.reduce({%MapSet{}, nil}, fn
        {coord, "#"}, {obstacles, guard} ->
          {MapSet.put(obstacles, coord), guard}

        {coord, "^"}, {obstacles, _} ->
          {obstacles, coord}
      end)

    %__MODULE__{
      guard: {:north, guard_coord},
      obstacles: obstacles,
      size: size
    }
  end

  # Creates a list indexing each element of interest
  @spec parse_row({binary(), non_neg_integer()}) :: [{coordinate(), binary()}]
  defp parse_row({row, row_number}) do
    :binary.matches(row, ["#", "^"])
    |> Enum.map(&{{row_number, elem(&1, 0)}, :binary.part(row, &1)})
    |> Enum.to_list()
  end

  @doc """
  Simulates guard movement through the board until loop or leave is detected.
  Returns a struct with the guard last position and path updated.
  """
  @spec calculate_guard_route(Day6.t()) :: {:leave | :loop, Day6.t()}
  def calculate_guard_route(
        %__MODULE__{guard: guard, obstacles: obstacles, path: path, size: size} =
          state
      ) do
    {_, new_guard_coord} = new_guard = move_guard(guard, obstacles)

    cond do
      path_contains_guard?(path, new_guard) ->
        {:loop, %__MODULE__{state | guard: new_guard}}

      guard_leave?(new_guard_coord, size) ->
        {:leave, %__MODULE__{state | guard: new_guard}}

      true ->
        state
        |> update_state(new_guard)
        |> calculate_guard_route()
    end
  end

  @spec update_state(Day6.t(), guard_position()) :: Day6.t()
  defp update_state(%__MODULE__{path: path} = state, new_guard) do
    %__MODULE__{state | guard: new_guard, path: MapSet.put(path, new_guard)}
  end

  @spec path_contains_guard?(board_obstacles(), guard_position()) :: boolean()
  defp path_contains_guard?(path, new_guard), do: MapSet.member?(path, new_guard)

  @spec guard_leave?(coordinate(), non_neg_integer()) :: boolean()
  defp guard_leave?({y, x}, size) do
    x < 0 or y < 0 or x >= size or y >= size
  end

  @spec count_positions(guard_path()) :: non_neg_integer()
  def count_positions(path) do
    path
    |> Enum.uniq_by(fn {_, pos} -> pos end)
    |> length()
  end

  @spec move_guard(guard_position(), board_obstacles()) :: guard_position()
  defp move_guard({:north, {y, x}} = guard, obstacles),
    do: move_turn_guard(guard, {y - 1, x}, obstacles)

  defp move_guard({:east, {y, x}} = guard, obstacles),
    do: move_turn_guard(guard, {y, x + 1}, obstacles)

  defp move_guard({:south, {y, x}} = guard, obstacles),
    do: move_turn_guard(guard, {y + 1, x}, obstacles)

  defp move_guard({:west, {y, x}} = guard, obstacles),
    do: move_turn_guard(guard, {y, x - 1}, obstacles)

  # If guard next position is an obstacle turn instead of forward
  @spec move_turn_guard(guard_position(), coordinate(), board_obstacles()) :: guard_position()
  defp move_turn_guard({facing, _} = guard, new_coord, obstacles) do
    if MapSet.member?(obstacles, new_coord) do
      turn_guard(guard)
    else
      {facing, new_coord}
    end
  end

  @spec turn_guard(guard_position()) :: guard_position()
  defp turn_guard({:north, coord}), do: {:east, coord}
  defp turn_guard({:east, coord}), do: {:south, coord}
  defp turn_guard({:south, coord}), do: {:west, coord}
  defp turn_guard({:west, coord}), do: {:north, coord}

  @doc """
  Function that creates as many obstacles as positions visited by the guard.
  Then simulate each map with additional obstacles and look for loops
  """
  @spec find_loop_obstructions(Day6.t()) :: Enumerable.t(coordinate())
  def find_loop_obstructions(%__MODULE__{} = initial_state) do
    {_, %__MODULE__{path: path}} = calculate_guard_route(initial_state)

    path
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq()
    |> Task.async_stream(&obstruction_makes_loop?(&1, initial_state))
    |> Enum.filter(&elem(&1, 1))
  end

  @spec obstruction_makes_loop?(coordinate(), Day6.t()) :: boolean()
  defp obstruction_makes_loop?({y, x}, %__MODULE__{guard: {_, {y, x}}}), do: false

  defp obstruction_makes_loop?(obstruction, %__MODULE__{obstacles: obstacles} = state) do
    obstruction_state = %__MODULE__{state | obstacles: MapSet.put(obstacles, obstruction)}

    case calculate_guard_route(obstruction_state) do
      {:loop, _} -> true
      {:leave, _} -> false
    end
  end
end
