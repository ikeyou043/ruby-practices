# frozen_string_literal: true

require 'optparse'

DEFAULT_MAX_WIDTH = 7

def parse_options
  options = {}
  opt = OptionParser.new
  opt.on('-l') { |v| options[:l] = v }
  opt.on('-w') { |v| options[:w] = v }
  opt.on('-c') { |v| options[:c] = v }
  opt.parse!(ARGV)
  options
end

def count_content(content)
  {
    lines: content.count("\n"),
    words: content.split.size,
    bytes: content.bytesize
  }
end

def build_file_counts(files)
  if files.empty? == true
    content = $stdin.read
    [count_content(content).merge(name: nil)]
  else
    files.map do |file|
      content = File.read(file)
      count_content(content).merge(name: file)
    end
  end
end

def selected_keys(options)
  keys = []
  keys << :lines if options[:l]
  keys << :words if options[:w]
  keys << :bytes if options[:c]
  return %i[lines words bytes] if keys.empty?

  keys
end

def format_wc(counts, options)
  keys = selected_keys(options)
  targets = build_targets_with_total(counts)
  max_width = calc_max_width(counts, targets, keys)
  targets.map { |count| format_line(count, keys, max_width) }.join("\n")
end

def build_targets_with_total(counts)
  targets = counts.dup
  return targets if counts.size <= 1

  targets << {
    lines: counts.sum { |c| c[:lines] },
    words: counts.sum { |c| c[:words] },
    bytes: counts.sum { |c| c[:bytes] },
    name: 'total'
  }
end

def calc_max_width(counts, targets, keys)
  return DEFAULT_MAX_WIDTH if counts.first[:name].nil?

  target_keys = counts.size == 1 && keys.size == 1 ? keys : %i[lines words bytes]
  targets.flat_map { |c| target_keys.map { |k| c[k].to_s.length } }.max
end

def format_line(count, keys, width)
  numbers = keys.map { |key| count[key].to_s.rjust(width) }.join(' ')
  count[:name] ? "#{numbers} #{count[:name]}" : numbers
end

def main
  options = parse_options
  files = ARGV.dup
  counts = build_file_counts(files)
  puts format_wc(counts, options)
end

main if __FILE__ == $PROGRAM_NAME
