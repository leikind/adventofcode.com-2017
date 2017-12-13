instructions = File.read_lines("./day5.txt").map { |l| l.to_i }

current_index = 0
steps_done = 0

def step_part1(instructions, current_index)
  instruction = instructions[current_index]
  instructions[current_index] += 1
  [instructions, current_index + instruction]
end

def step_part2(instructions, current_index)
  instruction = instructions[current_index]
  delta = instruction > 2 ? -1 : 1
  instructions[current_index] = instructions[current_index] + delta
  {instructions, current_index + instruction}
end

while current_index >= 0 && current_index < instructions.size
  # instructions, current_index = step_part1(instructions, current_index)
  instructions, current_index = step_part2(instructions, current_index)
  steps_done += 1
end

p steps_done
