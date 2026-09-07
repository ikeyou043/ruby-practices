# frozen_string_literal: true

require 'etc'

class FileInformation
  attr_reader :name

  PERM_MAP = {
    '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
    '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
  }.freeze

  def initialize(filename)
    @stat = File.lstat(filename)
    @name = filename
  end

  def mode
    octal = @stat.mode.to_s(8)

    file_type = if @stat.directory?
                  'd'
                elsif @stat.symlink?
                  'l'
                else
                  '-'
                end
    permissions = octal[-3..].chars.map { |n| PERM_MAP[n] }.join
    "#{file_type}#{permissions}"
  end

  def nlink
    @stat.nlink.to_s
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size.to_s
  end

  def mtime
    @stat.mtime.strftime('%b %e %H:%M')
  end

  def blocks
    @stat.blocks
  end
end
