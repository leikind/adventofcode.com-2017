input = [2, 8, 8, 5, 4, 2, 3, 1, 5, 5, 1, 2, 15, 13, 5, 14]

def tick(numbers : Array(Int32)) : Nil
  if idx_to_distribute = numbers.index(numbers.max)
    value_to_distribute = numbers[idx_to_distribute]
    numbers[idx_to_distribute] = 0
    n = idx_to_distribute + 1

    value_to_distribute.times do
      n = 0 if n >= numbers.size
      numbers[n] += 1
      n += 1
    end
  end
end

def solve(numbers : Array(Int32)) : Tuple(Int32, Int32)
  combinations = Hash(Array(Int32), Int32).new
  combinations[numbers.clone] = 0

  n = 1
  while true
    tick(numbers)
    if combinations.has_key?(numbers)
      break
    else
      n += 1
      combinations[numbers.clone] = n
    end
  end

  {n, n - combinations[numbers] + 1}
end

puts solve(input)

# 3156, 1610
