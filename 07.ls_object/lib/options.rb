# frozen_string_literal: true

require 'optparse'

class Options
  def initialize(argv)
    @all_files = false
    @reverse_files = false
    @long_format = false

    opt = OptionParser.new
    opt.on('-a') { @all_files = true }
    opt.on('-r') { @reverse_files = true }
    opt.on('-l') { @long_format = true }
    opt.parse!(argv)
  end

  def all_files?
    @all_files
  end

  def reverse_files?
    @reverse_files
  end

  def long_format?
    @long_format
  end
end
