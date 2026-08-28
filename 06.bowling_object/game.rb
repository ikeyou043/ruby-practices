# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(input)
    marks = input.split(',')
    @frames = build_frames(marks)
  end

  def total_score
    @frames.each_with_index.sum do |frame, i|
      frame.score + bonus_score(frame, i)
    end
  end

  private

  def build_frames(marks)
    frames = []

    # 1〜9フレーム目の作成
    9.times do
      first = marks.shift
      second = first == 'X' ? nil : marks.shift
      frames << Frame.new(first, second)
    end

    # 10フレーム目の作成（残りのマークをすべて渡す）
    frames << Frame.new(marks[0], marks[1], marks[2])
    frames
  end

  def bonus_score(frame, index)
    return 0 if index == 9

    if frame.strike?
      strike_bonus_score(index)
    elsif frame.spare?
      next_frame = @frames[index + 1]
      next_frame.first_shot.score
    else
      0
    end
  end

  def strike_bonus_score(index)
    next_frame = @frames[index + 1]
    shot1 = next_frame.first_shot.score

    shot2 = if next_frame.strike? && index < 8
              @frames[index + 2].first_shot.score
            else
              next_frame.second_shot.score
            end
    shot1 + shot2
  end
end
