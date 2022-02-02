# frozen_string_literal: true

# Imports
require_relative '../classes/grid'

# GameLogic module
module GameLogic
  def ask_player_input(player)
    puts "Player #{player} turn!"
    puts 'Please enter the column where you want to place your chip! (1-7)'
    gets.chomp.to_i - 1
  end
end
