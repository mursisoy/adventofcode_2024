defmodule Day4 do
  @moduledoc """
  --- Day 4: Ceres Search ---

  Solves: https://adventofcode.com/2024/day/4
  """
  @spec search_cross_word(Enumerable.t(binary()), binary()) :: non_neg_integer()
  @doc """
  Searches a word into a matrix horizontal, vertical, diagonal, written backwards, or even overlapping other words
  Strategy:
    Creates a block stream of length(word).
    These blocks are built in `to_block_stream` as astrings.
    Filter those matching the word forwards or backwards.
  """
  def search_word(word_search, word) do
    regex = ~r/(?:#{word}|#{String.reverse(word)})/
    block_length = String.length(word)

    word_search
    |> Stream.map(&String.codepoints/1)
    |> to_block_stream(block_length)
    |> Stream.filter(&String.match?(&1, regex))
    |> Enum.count()
  end

  @spec search_cross_word(Enumerable.t(binary()), binary()) :: non_neg_integer()
  @doc """
  Searches a word making a cross pattern inside a matrix, written backwards, or even overlapping other words
  Strategy:
    Get all `block_length` crosses inside matrix as strings.
    Filter those matching the cross word in any direction.
  """
  def search_cross_word(word_search, word) do
    regex = ~r/(?:#{word}|#{String.reverse(word)})/
    block_length = String.length(word)

    word_search
    |> Stream.map(&String.codepoints/1)
    |> diagonal_blocks_stream(block_length)
    |> Stream.map(&Enum.to_list/1)
    |> Stream.filter(&cross_match(&1, regex))
    |> Enum.count()
  end

  # Concat the resulting row, column and diagonal blocks of desired length.
  defp to_block_stream(matrix, block_length) do
    [
      row_blocks_stream(matrix, block_length),
      column_blocks_stream(matrix, block_length),
      diagonal_blocks_stream_flat(matrix, block_length)
    ]
    |> Stream.concat()
  end

  # Gets flat block list for every diagonal in every direction of length `block_length`
  defp diagonal_blocks_stream_flat(matrix, block_length) do
    matrix
    |> diagonal_blocks_stream(block_length)
    |> Stream.flat_map(&Function.identity/1)
  end

  # Get diagonals blocks from submatrix of `block_length` size
  # 1. Create submatrix by zipping chunks of columns and rows
  # From [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]
  # Get list of row chunks: [[["1", "2"], ["2", "3"]], [["4", "5"], ["5", "6"]], [["7", "8"], ["8", "9"]]]
  # Get list of column chunks: [
  #   [[["1", "2"], ["2", "3"]], [["4", "5"], ["5", "6"]]],
  #   [[["4", "5"], ["5", "6"]], [["7", "8"], ["8", "9"]]]
  #  ]
  # Zip the list: [
  #   {["1", "2"], ["4", "5"]},
  #   {["2", "3"], ["5", "6"]},
  #   {["4", "5"], ["7", "8"]},
  # ]
  # We are getting there, now we have a list of all the possible submatrix of length `block_length`
  # But we only want the diagonals, i.e. a list [[1,5],[2,4],...]
  # We get them from `&cross_blocks_stream/1`

  def diagonal_blocks_stream(matrix, block_length) do
    matrix
    |> Stream.map(&Stream.chunk_every(&1, block_length, 1, :discard))
    |> Stream.chunk_every(block_length, 1, :discard)
    |> Stream.flat_map(&Stream.zip/1)
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&cross_blocks_stream/1)
  end

  # Get both diagonals from matrix
  # From [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]
  # Get rows with index: [{["1", "2", "3"], 0}, {["4", "5", "6"], 1}, {["7", "8", "9"], 2}]
  # Discard non diagonals elements: [["1", "3"], ["5", "5"], ["9", "7"]]
  # Zip them [{"1", "5", "9"}, {"3", "5", "7"}]
  # Return strings: ["159", "357"]
  defp cross_blocks_stream(matrix) do
    matrix
    |> Stream.with_index()
    |> Stream.map(fn {row, i} -> [Enum.at(row, i), Enum.at(row, length(row) - 1 - i)] end)
    |> Stream.zip()
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&List.to_string/1)
  end

  # Creates a column block stream.
  # 1. Creates  chunks of `block_length` rows
  # 2. Map each group of rows with zip and then flat
  # 3. We got columns blocks of length `block_length`
  # 4. Get blocks as strings
  defp column_blocks_stream(matrix, block_length) do
    matrix
    |> Stream.chunk_every(block_length, 1, :discard)
    |> Stream.flat_map(&Stream.zip/1)
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&List.to_string/1)
  end

  # Creates a column block stream.
  # 1. Creates chunks for every row of `block_length` and then flat
  # 2. We got columns blocks of length `block_length`
  # 3. Get blocks as strings
  defp row_blocks_stream(matrix, block_length) do
    matrix
    |> Stream.flat_map(&Stream.chunk_every(&1, block_length, 1, :discard))
    |> Stream.map(&List.to_string/1)
  end

  defp cross_match([a, b], regex) do
    String.match?(a, regex) && String.match?(b, regex)
  end
end
