#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.map do |s|
  s == 'X' ? 10 : s.to_i
end
puts "入力スコア:#{shots}"

point = 0
pos = 0
10.times do |i|
  print "第#{i + 1}フレーム "
  if shots[pos] == 10
    puts "#{shots[pos]} , - ストライク"
    point += 10 + shots[pos + 1] + shots[pos + 2]
    pos += 1
  elsif (shots[pos] + shots[pos + 1]) == 10
    puts "#{shots[pos]} , #{shots[pos + 1]} スペア"
    point += 10 + shots [pos + 2]
    pos += 2
  else
    puts "#{shots[pos]} , #{shots[pos + 1]}"
    point += shots[pos] + shots[pos + 1]
    pos += 2
  end
end
puts "合計ポイント:#{point}"
