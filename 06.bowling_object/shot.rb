# frozen_string_literal: true

class Shot
  MAX_PINS = 10

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if @mark == 'X'

    @mark.to_i
  end
end
