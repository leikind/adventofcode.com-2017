module Day8
  REGEXP = %r{
    ([[:alpha:]]+)
    \s
    (inc|dec)
    \s
    (-?\d+)
    \s
    if
    \s
    ([[:alpha:]]+)
    \s
    ([<>=!]+)
    \s
    (-?\d+)
  }x

  extend self

  def each
    File.read_lines("./day8.txt").each do |line|
      if m = line.match(REGEXP)
        yield({m[1], m[2], m[3].to_i, m[4], m[5], m[6].to_i})
      end
    end
  end

  def solve
    registers = Hash(String, Int32).new

    instructions = Array(Tuple(String, String, Int32, String, String, Int32)).new

    max = 0

    each do |line|
      object_name, op1, mod, object_cond, op2, cond_val = line
      registers[object_name] = 0
      registers[object_cond] = 0

      instructions << {object_name, op1, mod, object_cond, op2, cond_val}
    end

    instructions.each do |object_name, op1, mod, object_cond, op2, cond_val|
      object_cond = registers[object_cond]
      check_result = case op2
                     when ">="
                       object_cond >= cond_val
                     when ">"
                       object_cond > cond_val
                     when "!="
                       object_cond != cond_val
                     when "=="
                       object_cond == cond_val
                     when "<="
                       object_cond <= cond_val
                     when "<"
                       object_cond < cond_val
                     else
                       raise op2
                     end

      if check_result
        if op1 == "dec"
          registers[object_name] -= mod
        else
          registers[object_name] += mod
        end
      end

      max = registers[object_name] if registers[object_name] > max
    end

    [registers.values.max, max]
  end
end

p Day8.solve
