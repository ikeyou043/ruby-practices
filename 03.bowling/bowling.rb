#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' # strike
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = frames.sum do |frame|
  if frame[0] == 10 # strike
    30
  elsif frame.sum == 10 # spare
    frame[0] + 10
  else
    frame.sum
  end
end
p frames
puts point
