defmodule Day5 do
  @moduledoc """
  --- Day 5: Print Queue ---

  Solves: https://adventofcode.com/2024/day/5
  """

  @type update() :: [integer()]
  @type rule() :: {integer(), integer()}

  @doc """
  Parse a string into a tuple of rules and updates
  """
  @spec parse(binary()) :: {Enumerable.t(rule()), Enumerable.t(update())}
  def parse(input) do
    [rules, updates] = String.split(input, ~r/^\n/m)
    {parse_rules(rules), parse_updates(updates)}
  end

  # Parse a rule string into a rules enum
  @spec parse_rules(binary()) :: Enumerable.t(rule())
  defp parse_rules(rules) do
    Regex.scan(~r/(\d+)\|(\d+)/m, rules, capture: :all_but_first)
    |> Enum.map(&List.to_tuple/1)
  end

  # Parses a rule string into an updates enum
  @spec parse_updates(binary()) :: Enumerable.t(update())
  defp parse_updates(updates) do
    updates
    |> String.split("\n")
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(&String.split(&1, ","))
  end

  @doc """
  Filter correct updates based on page ordering rules
  """
  @spec sum_middle_pages(Enumerable.t(update())) :: non_neg_integer()
  def sum_middle_pages(updates) do
    updates
    |> Stream.map(&Enum.at(&1, floor(length(&1) / 2)))
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @doc """
  Fixes an update if it is incorrect, based on the provided rules.

  The function iterates through each page, checking against the rules.
  If any page is incorrect, it swaps the pages using `&fix_incorrect_page/4`
  and restarts the process from the beginning.
  """
  @spec maybe_fix_update(update(), [rule()]) :: update()
  def maybe_fix_update(update, rules, fixed \\ [])
  def maybe_fix_update([], _, fixed), do: fixed |> Enum.reverse()

  def maybe_fix_update([page | post_pages], rules, fixed) do
    if update_rule_checker?(page, post_pages, rules) do
      maybe_fix_update(post_pages, rules, [page | fixed])
    else
      fix_incorrect_page(page, post_pages, [], rules)
      |> maybe_fix_update(rules, fixed)
    end
  end

  @spec fix_incorrect_page(integer(), update(), update(), [rule()]) :: update()
  defp fix_incorrect_page(page, [], tail, _), do: [page | tail |> Enum.reverse()]

  defp fix_incorrect_page(page, [next | post_pages], tail, rules) do
    if rule_check?(rules, {page, next}) do
      fix_incorrect_page(page, post_pages, [next | tail], rules)
    else
      [next | post_pages] ++ [page | tail |> Enum.reverse()]
    end
  end

  @spec update_correct?(update(), [rule()]) :: boolean()
  def update_correct?(update, rules)
  def update_correct?([], _), do: true

  def update_correct?([current | tail], rules) do
    if update_rule_checker?(current, tail, rules) do
      update_correct?(tail, rules)
    else
      false
    end
  end

  @spec update_rule_checker?(integer(), update(), [rule()]) :: boolean()
  defp update_rule_checker?(_, [], _), do: true

  defp update_rule_checker?(page, [next | tail], rules) do
    if rule_check?(rules, {page, next}) do
      update_rule_checker?(page, tail, rules)
    else
      false
    end
  end

  @spec rule_check?([rule()], rule()) :: boolean()
  defp rule_check?([], _), do: true
  defp rule_check?([{b, a} | _], {a, b}), do: false
  defp rule_check?([_ | rules], rule), do: rule_check?(rules, rule)
end
