require 'gosu'

class Cell
  attr_reader :alive

  def initialize(position)
    @x, @y = position
    @alive = false
  end

  def switch
    @alive = (not @alive)
  end
  
  def draw
    color = Gosu::Color::GREEN
    Gosu::draw_rect @x, @y, 10, 10, color, 0 if @alive
  end

  def x
    @x / 10
  end

  def y
    @y / 10
  end
end
