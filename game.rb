require 'yaml'
require_relative 'board'
require './tile.rb'
require 'colorize'


class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def play
    if File.exist?('game.yaml')
      puts "Would you like to continue your saved game?"
      new_game = gets.upcase.chomp
      load_file if new_game == "Y"
    end

    until game_over?
      display_grid
      position, action = prompt_user

      reveal_tile(position) if action == "R"
      flag_tile(position) if action == "F"

      save_file
    end

    system('clear')
    display_grid
    puts "You go, girl!".magenta.blink
    File.delete('game.yaml')
  end

  def display_grid
    system('clear')
    @board.display_inspect
    puts
  end

  def load_file
   game = YAML.load_file('game.yaml')
   @board = game.board
  end

  def save_file
    File.open('game.yaml', 'w') do |f|
      f.write(self.to_yaml)
    end
  end

  def prompt_user
    puts "What tile would you like to play on? (y x)"
    pos = gets.chomp.split.map(&:to_i)
    puts "Would you like to reveal (R) or flag (F) this tile?"
    action = gets.chomp.upcase

    [pos, action]
  end

  def reveal_tile(pos)
    x, y = pos
    tile = board.grid[x][y]

    tile.reveal unless tile.flagged?

    if tile.bomb?
      system('clear')
      tile.reveal
      board.display_inspect
      File.delete('game.yaml') if File.exist?('game.yaml')
      abort("Game over, loser.".red)
    end

    reveal_neighbors(pos)
  end

  def reveal_neighbors(pos)
    neighbors = board.neighbors(pos).delete_if do |x,y|
      board.grid[x][y].revealed?
    end

    neighbors.each do |n_x, n_y|
      neighbor = board.grid[n_x][n_y]
      neighbor.reveal unless neighbor.bomb?

      next if neighbor.bomb_count

      reveal_neighbors([n_x, n_y]) unless neighbor.flagged? || neighbor.bomb?
    end
  end

  def flag_tile(pos)
    x, y = pos

    board.grid[x][y].set_flag
  end


  def game_over?
    (board.flagged_positions.sort == board.bomb_positions.sort &&
    board.bomb_free_tiles.all?(&:revealed?)) ||
    (board.bomb_free_tiles.all?(&:revealed?) &&
    board.bomb_free_tiles.none?(&:flagged?))
  end
end

game = Game.new
game.play
