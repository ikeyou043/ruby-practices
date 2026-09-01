# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = second_mark ? Shot.new(second_mark) : nil
    @third_shot = third_mark ? Shot.new(third_mark) : nil
  end

  def score
    first_shot.score + (second_shot&.score || 0) + (third_shot&.score || 0)
  end

  def strike?
    first_shot.score == Shot::MAX_PINS
  end

  def spare?
    !strike? && (first_shot.score + (second_shot.score || 0) == Shot::MAX_PINS)
  end
end
