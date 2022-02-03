# frozen_string_literal: true

# Imports
require_relative '../modules/game_logic'
require_relative '../classes/grid'
require_relative '../classes/chip'

# Game class
class Game
  include GameLogic

  def initialize
    @current_player = 1
    @grid = Grid.new
  end

  def play
    introduction

    loop do
      column = ask_player_input(@current_player)
      @result = @grid.add_chip(column, Chip.new(player_to_symbol(@current_player)))
      break if @result.any? { |_, value| value == true }

      change_player
    end

    puts @result[:winner] ? "Player #{@current_player} wins! Congratulations!" : "It's a tie!"
  end

  private

  def introduction
    puts 'Lets play connect four!'
    puts 'Each player will have a turn to place a chip in any column.'
    puts 'The first one to have four chips horizontally, vertically or diagonally will win.'
  end

  def change_player
    @current_player = @current_player == 1 ? 2 : 1
  end

  def player_to_symbol(player)
    player == 1 ? 'Y' : 'R'
  end
end
