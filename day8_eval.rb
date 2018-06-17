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
    (
      [<>=!]+
      \s
      -?\d+
    )
  }x

  module_function

  def each
    File.readlines('./day8.txt').each do |line|
      if m = line.match(REGEXP)
        yield m[1..5]
      end
    end
  end

  def solve
    registers = {}
    exe_code = ''

    instructions = []

    max = 0


    each do |object_name, op, mod, object_cond, cond|

      registers[object_name.to_sym] = 0
      registers[object_cond.to_sym] = 0

      op = op == 'dec' ? '-= ' : '+= '
      obj = "registers[:#{object_name}]"

      exe_code << "#{obj} #{op} #{mod} if registers[:#{object_cond}] #{cond}\n"
      exe_code << "max = #{obj} if #{obj} > max\n"
    end

    eval(exe_code)

    [registers.values.max, max]
  end
end

p Day8.solve
