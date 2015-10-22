require 'gosu'
require_relative 'cell'

class GameWindow < Gosu::Window
  def initialize
    @width, @height = 800, 600
    super  @width, @height
    self.caption = "Conway's game of life"
    @font = Gosu::Font.new self, "ubuntu", 38
    @display_text = ""

    init_world_cells
  end
  
  def update
    update_world_cells
  end

  def draw
    draw_grid
    @font.draw @display_text, 20, 20, 2

    draw_world_cells
  end

  def button_down(id)
    clear_world_cells
    case id
    #The R-pentomino implementation
    when Gosu::Kb1
      @display_text = "R-pentomino"
      cell_at(40, 30).switch
      cell_at(40, 29).switch
      cell_at(39, 30).switch
      cell_at(40, 31).switch
      cell_at(41, 29).switch
    
    #The Diehard implementation
    when Gosu::Kb2
      @display_text = "Diehard"
      cell_at(37, 30).switch
      cell_at(36, 30).switch
      cell_at(37, 31).switch
      cell_at(41, 31).switch
      cell_at(42, 31).switch
      cell_at(43, 31).switch
      cell_at(42, 29).switch
    
    #The Acorn implementation
    when Gosu::Kb3
      @display_text = "Acorn"
      cell_at(49, 30).switch
      cell_at(47, 29).switch
      cell_at(47, 31).switch
      cell_at(46, 31).switch
      cell_at(50, 31).switch
      cell_at(51, 31).switch
      cell_at(52, 31).switch
    end
  end

  def update_world_cells
    switches = []
    
    @cells.each do |position, cell|
      if cell.alive
        switches << cell if neighbors_alive(cell) < 2 or neighbors_alive(cell) > 3
      else
        switches << cell if neighbors_alive(cell) == 3
      end
    end

    switches.each {|cell| cell.switch}
  end

  def draw_world_cells
    @cells.each do |position, cell|
      cell.draw
    end
  end

  def init_world_cells
    @cells = Hash.new

    (-10..90).each do |i|
      (-10..70).each do |j|
        @cells["#{i},#{j}"] ||= Cell.new [i * 10, j * 10]
      end
    end
  end

  def clear_world_cells
    @cells.each do |postion, cell|
      cell.switch if cell.alive
    end
  end
  
  def neighbors_alive(cell)
    count = 0

    unless cell.x == -10 or cell.x == 90 or cell.y == -10 or cell.y == 70
      neighbors = [cell_at(cell.x - 1, cell.y - 1),
                   cell_at(cell.x, cell.y - 1),
                   cell_at(cell.x + 1, cell.y - 1),
                   cell_at(cell.x - 1, cell.y),
                   cell_at(cell.x + 1, cell.y),
                   cell_at(cell.x - 1, cell.y + 1),
                   cell_at(cell.x, cell.y + 1),
                   cell_at(cell.x + 1, cell.y + 1)]

      neighbors.each do |neighbor|
        count += 1 if neighbor.alive
      end
    end

    return count
  end

  def cell_at(x, y)
    @cells["#{x},#{y}"]
  end

  def draw_grid
    color = Gosu::Color::GRAY
    x, y = 0, 0

    while x <= @width
      Gosu::draw_line x, 0, color, x, @height, color, 1
      x += 10
    end
    while y <= @height
      Gosu::draw_line 0, y, color, @width, y, color, 1
      y += 10
    end
  end
end

GameWindow.new.show
