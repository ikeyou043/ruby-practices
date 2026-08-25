# frozen_string_literal: true

MAX_COLUMNS = 3
MARGIN_WIDTH = 2

def format_in_columns(files, max_columns = MAX_COLUMNS)
  return '' if files.empty?

  row_count = files.size.fdiv(max_columns).ceil
  columns = files.each_slice(row_count).map { |slice| slice.values_at(0...row_count) }
  col_widths = columns.map { |col| col.compact.map(&:size).max || 0 }
  rows = columns.transpose

  formatted_lines = rows.map do |row|
    row.map.with_index do |file, col_idx|
      next if file.nil?

      file.to_s.ljust(col_widths[col_idx] + MARGIN_WIDTH)
    end.join.rstrip
  end

  formatted_lines.join("\n")
end

def main
  files = Dir.glob('*').sort
  puts format_in_columns(files)
end

main if __FILE__ == $PROGRAM_NAME