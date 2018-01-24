defmodule Day9 do

  def run(data) do
    data |> to_charlist |> loop(0, 0, :normal, 0)
  end

  defp loop([], _group_depth, total_score, _state, garbage_count) do
    {total_score, garbage_count}
  end

  # start next to cancel
  defp loop([ ?! | rest], group_depth, total_score, :garbage, garbage_count) do
    loop(rest, group_depth, total_score, :next_to_cancel, garbage_count)
  end

  # start next to cancel
  defp loop([ _char | rest], group_depth, total_score, :next_to_cancel, garbage_count) do
    loop(rest, group_depth, total_score, :garbage, garbage_count)
  end

  # start garbage
  defp loop([ ?< | rest], group_depth, total_score, :normal, garbage_count) do
    loop(rest, group_depth, total_score, :garbage, garbage_count)
  end

  # end garbage
  defp loop([ ?> | rest], group_depth, total_score, :garbage, garbage_count) do
    loop(rest, group_depth, total_score, :normal, garbage_count)
  end

  # start a group
  defp loop([ ?{ | rest], group_depth, total_score, :normal, garbage_count) do
    new_group_depth = group_depth + 1
    loop(rest, new_group_depth, total_score + new_group_depth, :normal, garbage_count)
  end

  # end a group
  defp loop([ ?} | rest], group_depth, total_score, :normal, garbage_count) do
    loop(rest, group_depth - 1, total_score, :normal, garbage_count)
  end

  defp loop([_char | rest], group_depth, total_score, :normal, garbage_count) do
    loop(rest, group_depth, total_score, :normal, garbage_count)
  end

  # a char inside garbage
  defp loop([_char | rest], group_depth, total_score, :garbage, garbage_count) do
    loop(rest, group_depth, total_score, :garbage, garbage_count + 1)
  end
end

{:ok, data} = File.read("day9.txt")
IO.inspect Day9.run(data)
