# frozen_string_literal: true
MAX_COLUMNS = 3
MARGIN_WIDTH = 3
def format_in_columns(files, max_columns = MAX_COLUMNS)
  return '' if files.empty?

  row_count = files.size.fdiv(max_columns).ceil
  sliced_files = files.each_slice(row_count).map { |slices| slices.values_at(0...row_count) }
  rows = sliced_files.transpose

  max_width = files.map(&:size).max

  formatted_lines = rows.map do |row|
    row.map { |file| file.to_s.ljust(max_width + MARGIN_WIDTH) }.join.rstrip
  end

  formatted_lines.join("\n")
end

def main
  # ファイル一覧を取得するメソッド
  files = Dir.glob('*').sort
  puts format_in_columns(files)
end

main if __FILE__ == $PROGRAM_NAME
