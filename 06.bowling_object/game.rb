# frozen_string_literal: true

require_relative 'frame'

class Game
  TOTAL_FRAMES = 10
  LAST_FRAME_INDEX = (TOTAL_FRAMES - 1)
  NORMAL_FRAME_INDEX = (TOTAL_FRAMES - 2)

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

    LAST_FRAME_INDEX.times do
      first = marks.shift
      second = first == 'X' ? nil : marks.shift
      frames << Frame.new(first, second)
    end

    frames << Frame.new(marks[0], marks[1], marks[2])
    frames
  end

  def bonus_score(frame, index)
    return 0 if index == LAST_FRAME_INDEX

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

    shot2 = if next_frame.strike? && index < NORMAL_FRAME_INDEX
              @frames[index + 2].first_shot.score
            else
              next_frame.second_shot.score
            end
    shot1 + shot2
  end
end
