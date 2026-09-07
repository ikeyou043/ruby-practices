# frozen_string_literal: true

require_relative 'file_information'

class FileList
  MAX_COLUMNS = 3
  MARGIN_WIDTH = 2

  def initialize(directory, options)
    file_names = options.all_files? ? Dir.entries(directory) : Dir.glob('*', base: directory)
    file_names = file_names.sort
    file_names = file_names.reverse if options.reverse_files?
    @file_informations = file_names.map { |name| FileInformation.new(name) }
    @options = options
  end

  def to_s
    @options.long_format? ? long_format : columns_format
  end

  private

  def long_format
    return '' if @file_informations.empty?

    total_blocks = @file_informations.sum(&:blocks) / 2
    column_widths = calc_max_widths
    lines = @file_informations.map { |info| format_file_row(info, column_widths) }
    ["total #{total_blocks}", *lines].join("\n")
  end

  def calc_max_widths
    %i[nlink owner group size].to_h do |key|
      [key, @file_informations.map { |info| info.public_send(key).length }.max]
    end
  end

  def format_file_row(info, widths)
    nlink = info.nlink.rjust(widths[:nlink])
    owner = info.owner.ljust(widths[:owner])
    group = info.group.ljust(widths[:group])
    size = info.size.rjust(widths[:size])
    "#{info.mode} #{nlink} #{owner} #{group} #{size} #{info.mtime} #{info.name}"
  end

  def columns_format
    names = @file_informations.map(&:name)
    return '' if names.empty?

    row_count = names.size.fdiv(MAX_COLUMNS).ceil
    columns = names.each_slice(row_count).map { |slice| slice.values_at(0...row_count) }
    column_widths = columns.map { |col| col.compact.map(&:size).max }
    rows = columns.transpose
    rows.map { |row| format_columns_row(row, column_widths) }.join("\n")
  end

  def format_columns_row(row, column_widths)
    row.map.with_index do |file, col_idx|
      file&.to_s&.ljust(column_widths[col_idx] + MARGIN_WIDTH)
    end.join.rstrip
  end
end
