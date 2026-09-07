# frozen_string_literal: true

require_relative 'options'
require_relative 'file_list'

options = Options.new(ARGV)
file_list = FileList.new('.', options)
puts file_list
