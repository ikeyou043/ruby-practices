#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(input)
    shots = input.split(',').map { |mark| Shot.new(mark) }
    @frames = build_frames(shots)
  end

  def total_score
    @frames.each_with_index.sum do |frame, i|
      frame.score + bonus_score(frame, i)
    end
  end

  private

  def build_frames(shots)
    frames = []

    9.times do
      frame_shots = if shots.first.score == 10
                      shots.shift(1)
                    else
                      shots.shift(2)
                    end
      frames << Frame.new(frame_shots)
    end

    frames << Frame.new(shots)
    frames
  end

  def bonus_score(frame, index)
    return 0 if index == 9

    if frame.strike?
      strike_bonus_score(index)
    elsif frame.spare?
      spare_bonus_score(index)
    else
      0
    end
  end

  def strike_bonus_score(index)
    next_frame = @frames[index + 1]
    next_shot1 = next_frame.shots[0]
    next_shot2 = second_strike_bonus_shot(next_frame, index)
    @frames[index].strike_bonus(next_shot1, next_shot2)
  end

  def second_strike_bonus_shot(next_frame, index)
    if next_frame.strike? && index < 8
      @frames[index + 2].shots[0]
    else
      next_frame.shots[1]
    end
  end

  def spare_bonus_score(index)
    next_shot = @frames[index + 1].shots[0]
    @frames[index].spare_bonus(next_shot)
  end
end
