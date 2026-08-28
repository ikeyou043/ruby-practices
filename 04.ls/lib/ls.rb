# frozen_string_literal: true

require 'optparse'

MAX_COLUMNS = 3
MARGIN_WIDTH = 3

def parse_options
  options = {}
  opt = OptionParser.new
  opt.on('-r') { |v| options[:r] = v }
  opt.parse!(ARGV)
  options
end

def format_in_columns(files, max_columns = MAX_COLUMNS)
  return '' if files.empty?

  row_count = files.size.fdiv(max_columns).ceil
  columns = files.each_slice(row_count).map { |slice| slice.values_at(0...row_count) }
  col_widths = columns.map { |col| col.compact.map(&:size).max || 0 }
  rows = columns.transpose

  rows.map { |row| format_row(row, col_widths) }.join("\n")
end

def format_row(row, col_widths)
  row.map.with_index do |file, col_idx|
    file&.to_s&.ljust(col_widths[col_idx] + MARGIN_WIDTH)
  end.join.rstrip
end

def main
  options = parse_options
  files = Dir.glob('*').sort
  files = files.reverse if options[:r] # -r オプション指定時のみ反転
  puts format_in_columns(files)
end

main if __FILE__ == $PROGRAM_NAME
