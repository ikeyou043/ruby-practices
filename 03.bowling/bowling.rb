#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.map do |s|
  s == 'X' ? 10 : s.to_i
end

point = 0
pos = 0
10.times do
  if shots[pos] == 10
    point += 10 + shots[pos + 1] + shots[pos + 2]
    pos += 1
  elsif (shots[pos] + shots[pos + 1]) == 10
    point += 10 + shots [pos + 2]
    pos += 2
  else
    point += shots[pos] + shots[pos + 1]
    pos += 2
  end
end
puts point
