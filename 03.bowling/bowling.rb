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
puts "入力スコア:#{shots}"
frames = shots.each_slice(2).to_a
puts "フレームスコア:#{frames}"
# ストライク状態とスペア状態の記憶フラッグ
strike_frag = 0
spare_frag = 0
# 現在のフレーム数を記録
i = 0
point = frames.sum do |frame|
  i += 1
  puts "第#{i}フレーム:#{frame}"
  if strike_frag == 1
    print 'ストライク'
    frame_score = frame.sum * 2

  elsif spare_frag == 1
    print 'スペア'
    frame_score = frame[0] * 2 + frame[1]

  else
    print '-'
    frame_score = frame.sum
  end
  puts "=>#{frame_score}点"
  if frame[0] == 10 # strike
    strike_frag = 1
    spare_frag = 0
  elsif frame.sum == 10 # spare
    strike_frag = 0
    spare_frag = 1
  else
    strike_frag = 0
    spare_frag = 0
  end
  frame_score
end

puts point
