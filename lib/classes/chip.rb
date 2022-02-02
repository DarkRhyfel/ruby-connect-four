# frozen_string_literal: true

# Chip class
class Chip
  attr_accessor :value, :sibling_left, :sibling_right, :child_left, :child_right, :child_center

  def initialize(value)
    @value = value

    @sibling_left = nil
    @sibling_right = nil

    @child_left = nil
    @child_right = nil
    @child_center = nil
  end
end
