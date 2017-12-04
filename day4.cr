
lines_of_words = File
  .read_lines("./day4.txt")
  .map{|row| row.split(/\s+/)}

# part 1
p lines_of_words
  .select{|words| words.uniq.size == words.size }
  .size

# part 2
p lines_of_words
  .select { |words|
    words_with_characters_sorted = words.map{|w| w.chars.sort}
    words.uniq.size == words.size &&
    words_with_characters_sorted.uniq.size == words_with_characters_sorted.size
  }.size
