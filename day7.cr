require "set"

module Day7
  REGEXP = %r{
    ([[:alpha:]]+)
    \s
    \((\d+)\)
    (
      \s
      ->
      \s
      ([\w\s,]+)
    )?
    $
  }x

  extend self

  def parse(fname)
    File.read_lines(fname).each do |line|
      if m = line.match(REGEXP)
        parent = m[1]
        weight = m[2].to_i
        leaves = m[4]? ? m[4].chomp.split(", ") : Array(String).new
        yield parent, weight, leaves
      end
    end
  end

  def find_root(fname)
    nodes_set = Set(String).new
    leaves_set = Set(String).new

    Day7.parse(fname) do |parent, _weight, leaves|
      nodes_set << parent
      leaves.each { |l| nodes_set << l }
      leaves.each { |l| leaves_set << l }
    end

    (nodes_set - leaves_set).to_a[0]
  end

  def find_invalid(fname)
    weights, parent_children_table = get_relations(fname)

    problematic_cases = parent_children_table.map do |_parent, children|
      children_branch_weights = children.map do |ch|
        branch_weight = get_branch_weight(ch, weights, parent_children_table)
        {ch, branch_weight}
      end
      uniq_weights = children_branch_weights.map { |i| i[1] }.uniq
      {children_branch_weights, uniq_weights}
    end.select do |_children_branch_weights, uniq_weights|
      uniq_weights.size != 1
    end.map do |children_branch_weights, uniq_weights|
      weight_with_their_occurence = uniq_weights
        .map { |w| {children_branch_weights.count { |item| item[1] == w }, w} }
        .sort_by { |item| item[0] }

      winning_number : Int32 = weight_with_their_occurence[-1][1]
      number_to_be_fixed : Int32 = weight_with_their_occurence[0][1]

      {children_branch_weights, winning_number, number_to_be_fixed}
    end

    if lighest_branch_problematic_case = problematic_cases.sort_by { |i| i[1] }[0]
      children_branch_weights, winning_number, number_to_be_fixed = lighest_branch_problematic_case

      diff = winning_number - number_to_be_fixed
      if (nodes_to_be_fixed = children_branch_weights.find { |i| i[1] == number_to_be_fixed }) &&
         (node_to_be_fixed = nodes_to_be_fixed[0]) &&
         weights[node_to_be_fixed]
        weights[node_to_be_fixed] + diff
      end
    end
  end

  def get_branch_weight(node : String, weights : Hash(String, Int32), parent_children_table : Hash(String, Array(String))) : Int32
    weights[node] +
      if parent_children_table.has_key?(node)
        parent_children_table[node].map { |ch| get_branch_weight(ch, weights, parent_children_table).as(Int32) }.sum
      else
        0
      end
  end

  def get_relations(fname : String) : Tuple(Hash(String, Int32), Hash(String, Array(String)))
    weights = Hash(String, Int32).new
    parent_children_table = Hash(String, Array(String)).new

    Day7.parse(fname) do |parent, weight, leaves|
      weights[parent] = weight
      unless leaves.empty?
        parent_children_table[parent] = leaves
      end
    end
    {weights, parent_children_table}
  end
end

p Day7.find_root("./day7.txt")    # vvsvez
p Day7.find_invalid("./day7.txt") # 362
