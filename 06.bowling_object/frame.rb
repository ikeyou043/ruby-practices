#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def score
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && score == 10
  end

  def spare_bonus(next_shot)
    next_shot.score
  end

  def strike_bonus(next_shot1, next_shot2)
    next_shot1.score + next_shot2.score
  end
end
