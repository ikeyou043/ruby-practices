# frozen_string_literal: true

require 'optparse'

DEFAULT_MAX_WIDTH = 7

def main
  options = parse_options
  files = ARGV.dup
  counts = build_file_counts(files)
  puts result(counts, options)
end

def parse_options
  options = {}
  opt = OptionParser.new
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  opt.parse!(ARGV)
  options
end

def build_file_counts(files)
  if files.empty?
    content = $stdin.read
    [count_content(content)]
  else
    files.map do |file|
      content = File.read(file)
      count_content(content, name: file)
    end
  end
end

def count_content(content, name: nil)
  {
    lines: content.count("\n"),
    words: content.split.size,
    bytes: content.bytesize,
    name: name
  }
end

def result(counts, options)
  keys = selected_keys(options)
  targets = build_targets_with_total(counts)
  max_width = calc_max_width(targets, keys)
  targets.map { |count| format_line(count, keys, max_width) }.join("\n")
end

def selected_keys(options)
  keys = []
  keys << :lines if options[:l]
  keys << :words if options[:w]
  keys << :bytes if options[:c]
  keys.empty? ? %i[lines words bytes] : keys
end

def build_targets_with_total(counts)
  return counts if counts.size <= 1

  total = {
    lines: counts.sum { |c| c[:lines] },
    words: counts.sum { |c| c[:words] },
    bytes: counts.sum { |c| c[:bytes] },
    name: 'total'
  }
  [*counts, total]
end

def calc_max_width(targets, keys)
  if targets.first[:name].nil?
    return keys.size == 1 ? targets.first[keys.first].to_s.length : DEFAULT_MAX_WIDTH

  end

  target_keys = targets.size == 1 && keys.size == 1 ? keys : %i[lines words bytes]
  target_keys.map { |k| targets.last[k].to_s.length }.max
end

def format_line(count, keys, width)
  numbers = keys.map { |key| count[key].to_s.rjust(width) }
  numbers << count[:name] if count[:name]
  numbers.join(' ')
end

main if __FILE__ == $PROGRAM_NAME
