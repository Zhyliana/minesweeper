require 'colorize'

class Board
  attr_reader :grid, :grid_size

  DELTA = [[0, 1], [0, -1], [1, 0], [-1, 0],
          [-1, 1], [-1, -1], [1, -1], [1, 1]]

  def initialize(grid_size = 9)
    @grid_size = grid_size
    @grid = Array.new(grid_size) { Array.new(grid_size) }
    populate_grid
  end


  def colorize_bomb_count(bomb_count)
    case bomb_count
    when "1"
      bomb_count.colorize(:yellow)
    when "2"
      bomb_count.colorize(:light_green)
    when "3"
      bomb_count.colorize(:light_cyan)
    when "4"
      bomb_count.colorize(:blue).bold
    else
      bomb_count.colorize(:red).bold
    end
  end

  def display_inspect
    grid.each_with_index do |row, idx|
      inspect_row = row.map do |tile|
        if tile.revealed?
          if tile.bomb_count
            colorize_bomb_count("#{tile.bomb_count}")
          elsif tile.bomb?
            "\u2736".encode('utf-8').colorize(:color => :red).blink
          else
            " "
          end
        elsif tile.flagged?
          "\u2691".encode('utf-8').red 
        elsif
          tile.bomb? && !tile.revealed?
          "\u25A0".encode('utf-8').light_white
        else
          "\u25A0".encode('utf-8').light_white
        end
      end.join(" ")

      puts "#{idx}".light_white + " #{inspect_row}"
    end

    puts "  0 1 2 3 4 5 6 7 8".light_white
  end

  def populate_grid
    populate_bombs

    grid.each_with_index do |row, r_idx|
      row.each_with_index do |col, c_idx|
        grid[r_idx][c_idx] = Tile.new unless grid[r_idx][c_idx]
      end
    end

    set_bomb_count
  end

  def populate_bombs
    bomb_count = 0

    until bomb_count == 10
      x = (0...grid_size).to_a.sample
      y = (0...grid_size).to_a.sample

      unless grid[x][y]
        tile = Tile.new
        tile.set_bomb
        grid[x][y] = tile
        bomb_count += 1
      end
    end
  end

  def set_bomb_count
    bomb_positions.each do |x, y|
      neighbors([x,y]).each do |n_x, n_y|
        tile = grid[n_x][n_y]
        next if tile.bomb?

        tile.bomb_count ||= 0
        tile.bomb_count += 1
      end
    end
  end

  def bomb_positions
    bomb_list = []

    grid.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        bomb_list << [x, y] if grid[x][y].bomb?
      end
    end

    bomb_list
  end

  def bomb_free_tiles
    grid.flatten.reject {|tile| tile.bomb?}
  end

  def flagged_positions
    flagged_list = []

    grid.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        flagged_list << [x, y] if grid[x][y].flagged?
      end
    end

    flagged_list
  end

  def neighbors(pos)
    x, y = pos
    neighbors = []

    DELTA.each do |d_x, d_y|
      new_x, new_y = (x + d_x), (y + d_y)
      next unless new_x.between?(0, grid_size-1) && new_y.between?(0, grid_size-1)
      neighbors << [new_x, new_y]
    end

    neighbors
  end
end