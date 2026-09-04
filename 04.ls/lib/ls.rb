# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMNS = 3
MARGIN_WIDTH = 2

def parse_options
  options = {}
  opt = OptionParser.new
  opt.on('-l') { |v| options[:l] = v }
  opt.parse!(ARGV)
  options
end

PERM_MAP = {
  '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
  '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
}.freeze

def format_mode(stat)
  octal = stat.mode.to_s(8)

  file_type = if stat.directory?
                'd'
              elsif stat.symlink?
                'l'
              else
                '-'
              end

  permissions = octal[-3..].chars.map { |n| PERM_MAP[n] }.join

  "#{file_type}#{permissions}"
end

def build_file_info(file)
  stat = File.stat(file)
  {
    mode: format_mode(stat),
    nlink: stat.nlink.to_s,
    owner: Etc.getpwuid(stat.uid).name,
    group: Etc.getgrgid(stat.gid).name,
    size: stat.size.to_s,
    mtime: stat.mtime.strftime('%b %d %H:%M'),
    name: file,
    blocks: stat.blocks
  }
end

def format_long_format(files)
  return '' if files.empty?

  file_infos = files.map { |file| build_file_info(file) }
  total_blocks = file_infos.sum { |info| info[:blocks] } / 2
  column_width = calc_max_widths(file_infos)

  lines = file_infos.map { |info| format_file_row(info, column_width) }
  ["total #{total_blocks}", *lines].join("\n")
end

def calc_max_widths(file_infos)
  %i[nlink owner group size].to_h do |key|
    [key, file_infos.map { |info| info[key].length }.max]
  end
end

def format_file_row(info, widths)
  nlink = info[:nlink].rjust(widths[:nlink])
  owner = info[:owner].ljust(widths[:owner])
  group = info[:group].ljust(widths[:group])
  size = info[:size].rjust(widths[:size])
  "#{info[:mode]} #{nlink} #{owner} #{group} #{size} #{info[:mtime]} #{info[:name]}"
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
  if options[:l]
    puts format_long_format(files)
  else
    puts format_in_columns(files)
  end
end

main if __FILE__ == $PROGRAM_NAME
