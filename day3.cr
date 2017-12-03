module Day3
  extend self

  def find_next_right_bottom_corner_number(input)
    row_size = Math.sqrt(input).ceil.to_i
    row_size +=1 if row_size.even?
    [row_size * row_size, row_size]
  end

  def diff_to_the_closest_corner(input, next_right_bottom_corner_number, row_size)
    previous_corner = next_right_bottom_corner_number - row_size + 1
    if input > previous_corner
      [input - previous_corner, next_right_bottom_corner_number - input].min
    else
      diff_to_the_closest_corner(input, previous_corner, row_size)
    end
  end

  def solve(input)
    next_right_bottom_corner_number, row_size = find_next_right_bottom_corner_number(input)
    diff = diff_to_the_closest_corner(input, next_right_bottom_corner_number, row_size)
    row_size - 1 - diff
  end
end

puts Day3.solve(312051)
