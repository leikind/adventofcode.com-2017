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
    init_code = ''
    exe_code = ''
    max = 0

    each do |object_name, op, mod, object_cond, cond|
      init_code << "registers[:#{object_name}] = registers[:#{object_cond}] = 0\n"

      op = op == 'dec' ? '-= ' : '+= '
      obj = "registers[:#{object_name}]"

      exe_code << "#{obj} #{op} #{mod} if registers[:#{object_cond}] #{cond}\n"
      exe_code << "max = #{obj} if #{obj} > max\n"
    end

    eval(init_code)
    eval(exe_code)

    [registers.values.max, max]
  end
end

p Day8.solve
