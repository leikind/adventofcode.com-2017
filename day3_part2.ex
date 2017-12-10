# Solution for the second part of http://adventofcode.com/2017/day/3

# BTW Stream.unfold and Stream.transform and Enum.flat_map_reduce ROCK!!!

# direction_stream returns an infinite stream of direction instructions:
# :up, :left, :left, :down, :down, :right, :right, :right, :up, :up, :up, :left,
# :left, :left, :left, :down, :down, :down, :down, :right, :right, :right,
# :right, :right, :up, :up, :up, :up, :up, :left ....

generator_func = fn
  {:up,    max_steps, max_steps} -> {:left, {:left,   max_steps + 1, 0}}
  {:up,    max_steps, step}      -> {:up,   {:up,     max_steps,     step+1}}

  {:left,  max_steps, max_steps} -> {:down, {:down,   max_steps,     0}}
  {:left,  max_steps, step}      -> {:left, {:left,   max_steps,     step+1}}

  {:down,  max_steps, max_steps} -> {:right, {:right, max_steps + 1, 0}}
  {:down,  max_steps, step}      -> {:down,  {:down,  max_steps,     step+1}}

  {:right, max_steps, max_steps} -> {:up,    {:up,    max_steps,     0}}
  {:right, max_steps, step}      -> {:right, {:right, max_steps,     step+1}}
end

direction_stream = Stream.unfold({:right, 0, 0}, generator_func)

# direction_stream
# |> Stream.take(30)
# |> Enum.to_list()
# |> IO.inspect

# stream_of_coordinates transforms direction_stream into an infinite stream of coordinates:
# {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}, {2, -1}, {2, 0},
# {2, 1}, {2, 2}, {1, 2}, {0, 2}, {-1, 2}, {-2, 2}, {-2, 1}, {-2, 0}, {-2, -1},
# {-2, -2}, {-1, -2}, {0, -2}, {1, -2}

stream_of_coordinates = Stream.transform(
  direction_stream,
  {1, 0},
  fn (direction, {x,y}) ->
    next_position = case direction do
      :up    -> {x, y+1}
      :left  -> {x-1, y}
      :down  -> {x, y-1}
      :right -> {x+1, y}
    end
    { [next_position], next_position}
  end
)

# stream_of_coordinates
# |> Stream.take(30)
# |> Enum.to_list()
# |> IO.inspect

defmodule Matrix do

  def initial_matrix, do: Map.new([
    {{0, 0}, 1},
    {{1, 0}, 1}
  ])

  def sample_matrix, do: Map.new([
    {{6, 5}, 1}, {{6, 6}, 2},
    {{5, 6}, 3}, {{4, 6}, 4},
    {{4, 5}, 5}, {{4, 4}, 6},
    {{5, 4}, 7}, {{6, 4}, 8},
  ])

  def sum_of_neigbour_values(matrix, {x, y}) do
    for xx <- (x-1..x+1), yy <- (y-1..y+1), {xx, yy} != {x, y} do
      matrix |> Map.get({xx, yy}, 0)
    end
    |> Enum.sum
  end

  def print_matrix(matrix) do
    {all_xs, all_ys} = matrix |> Map.keys |>  Enum.unzip

    Enum.each(Enum.max(all_ys)..Enum.min(all_ys), fn(y) ->
      Enum.each(Enum.min(all_xs)..Enum.max(all_xs), fn(x) ->
        # IO.write(inspect([x, y]))
        case Map.fetch(matrix, {x, y}) do
          :error -> IO.write("     ")
          {:ok, n} -> n
            |> Integer.to_string
            |> String.pad_leading(5)
            |> :io.format
        end
      end)
      IO.puts("")
    end)
  end
end

# Will print the matrix exactly like in the task
{_, matrix_as_in_the_example} = Enum.flat_map_reduce(
  stream_of_coordinates,
  Matrix.initial_matrix,
  fn (coordinates, matrix) ->

    new_matrix = Map.put_new(
      matrix,
      coordinates,
      Matrix.sum_of_neigbour_values(matrix, coordinates)
    )

    if coordinates == {0, -2} do
      {:halt, new_matrix}
    else
      {[], new_matrix}
    end
  end
)

IO.puts "Sample matrix like in the task:"
Matrix.print_matrix(matrix_as_in_the_example)
# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
# 362  747  806

puzzle_input = 312051

{_, first_value_larger_than_puzzle_input} = Enum.flat_map_reduce(
  stream_of_coordinates,
  Matrix.initial_matrix,
  fn (coordinates, matrix) ->

    value_to_write = Matrix.sum_of_neigbour_values(matrix, coordinates)

    new_matrix = Map.put_new(matrix, coordinates, value_to_write)

    if value_to_write > puzzle_input do
      {:halt, value_to_write}
    else
      {[], new_matrix}
    end
  end
)

IO.puts "\n\nAnd the answer is..."
IO.puts first_value_larger_than_puzzle_input
