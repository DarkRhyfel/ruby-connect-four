# frozen_string_literal: true

# Grid class
class Grid
  attr_reader :board

  def initialize
    @board = Array.new(7) { [] }
  end

  def add_chip(column, chip)
    return 'Column is already full, place your chip in another one!' unless board[column].length < 6

    row = board[column].length
    board[column].push(chip)

    print_board

    update_children(column, row, chip)
    check_connect_four(chip)
  end

  def update_children(column, row, chip)
    prev_column = column - 1
    post_column = column + 1
    prev_row = row - 1

    update_sibling(prev_column, post_column, row, chip)
    update_child(prev_column, column, post_column, prev_row, chip)
  end

  def check_connect_four(chip)
    results =
      [
        1 + check_child(chip, chip.sibling_left, 0),
        1 + check_child(chip, chip.sibling_right, 1),
        1 + check_child(chip, chip.child_left, 2),
        1 + check_child(chip, chip.child_center, 3),
        1 + check_child(chip, chip.child_right, 4)
      ]
    results.any? { |result| result == 4 } ? true : false
  end

  private

  def update_sibling(prev_column, post_column, row, chip)
    chip.sibling_left = board[prev_column][row] if prev_column > -1
    chip.sibling_right = board[post_column][row] if post_column < 7
  end

  def update_child(prev_column, column, post_column, prev_row, chip)
    chip.child_left = board[prev_column][prev_row] if prev_column > -1 && prev_row > -1
    chip.child_center = board[column][prev_row] if prev_row > -1
    chip.child_right = board[post_column][prev_row] if post_column < 7 && prev_row > -1
  end

  def check_child(root, chip, direction)
    return 0 if chip.nil? || chip.value != root.value

    next_child =
      case direction
      when 0 then chip.sibling_left
      when 1 then chip.sibling_right
      when 2 then chip.child_left
      when 3 then chip.child_center
      else chip.child_right
      end

    1 + check_child(root, next_child, direction)
  end

  def print_board
    puts "\n\n"
    6.times do |i|
      i = 5 - i
      7.times { |j| print board[j][i].nil? ? '|   ' : "| #{board[j][i].value} " }
      print "|\n"
    end
    puts '-----------------------------'
    puts "\n\n"
  end
end
