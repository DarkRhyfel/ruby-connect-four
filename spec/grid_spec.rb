# frozen_string_literal: true

# Class require
require_relative '../lib/classes/grid'
require_relative '../lib/classes/chip'

# Test definition for Grid
RSpec.describe Grid do # rubocop:disable Metrics/BlockLength
  subject(:grid) { Grid.new }

  describe '#add_chip' do # rubocop:disable Metrics/BlockLength
    let(:chip_p1) { Chip.new('Y') }

    context 'when a player adds a chip to empty spot' do
      it 'sets the spot with the current player chip' do
        column = 0

        grid.add_chip(column, chip_p1)
        expect(grid.board[column][0]).to eq(chip_p1)
      end

      it 'requests children to be set for added chip' do
        column = 0
        row = 0

        expect(grid).to receive(:update_children).with(column, row, chip_p1)
        grid.add_chip(column, chip_p1)
      end

      it 'requests a check to see if the chip triggers a win' do
        column = 0

        expect(grid).to receive(:check_connect_four).with(chip_p1)
        grid.add_chip(column, chip_p1)
      end

      it 'requests to print the board' do
        column = 0

        expect(grid).to receive(:print_board)
        grid.add_chip(column, chip_p1)
      end
    end

    context 'when a player adds a chip to full column' do
      let(:column) { 0 }

      before do
        allow(grid.board[column]).to receive(:length).and_return(6)
      end

      it 'returns an error message' do
        error_message = 'Column is already full, place your chip in another one!'

        result = grid.add_chip(column, chip_p1)
        expect(result).to eq(error_message)
      end
    end
  end

  describe '#update_children' do # rubocop:disable Metrics/BlockLength
    let(:chip_p1) { Chip.new('Y') }

    let(:sibling_left_chip_p1) { Chip.new('Y') }
    let(:sibling_right_chip_p1) { Chip.new('Y') }
    let(:child_left_chip_p1) { Chip.new('Y') }
    let(:child_center_chip_p1) { Chip.new('Y') }
    let(:child_right_chip_p1) { Chip.new('Y') }

    context 'when a chip is added' do
      before do
        grid.add_chip(0, child_left_chip_p1)
        grid.add_chip(0, sibling_left_chip_p1)
        grid.add_chip(1, child_center_chip_p1)
        grid.add_chip(2, child_right_chip_p1)
        grid.add_chip(2, sibling_right_chip_p1)

        column = 1
        row = 1

        grid.update_children(column, row, chip_p1)
      end

      it 'sets the chip siblings' do
        expect(chip_p1.sibling_left).to eq(sibling_left_chip_p1)
        expect(chip_p1.sibling_right).to eq(sibling_right_chip_p1)
      end

      it 'sets the chip children' do
        expect(chip_p1.child_left).to eq(child_left_chip_p1)
        expect(chip_p1.child_right).to eq(child_right_chip_p1)
        expect(chip_p1.child_center).to eq(child_center_chip_p1)
      end
    end
  end

  describe '#check_connect_four' do # rubocop:disable Metrics/BlockLength
    let(:chip_p1) { Chip.new('Y') }

    context 'after a chip has been linked with its children' do # rubocop:disable Metrics/BlockLength
      context 'there is no winner (chip has no links)' do
        it 'returns no winner and not full board' do
          result = grid.check_connect_four(chip_p1)
          expect(result).to eq({ winner: false, full_board: false })
        end
      end

      context 'there is no winner (chip does not have 3 depth children)' do
        before do
          allow(grid).to receive(:check_child).and_return(2, 2, 2, 1, 1)
        end

        it 'returns no winner and not full board' do
          result = grid.check_connect_four(chip_p1)
          expect(result).to eq({ winner: false, full_board: false })
        end
      end

      context 'there is a winner (chip has 3 depth children)' do
        before do
          allow(grid).to receive(:check_child).and_return(0, 1, 2, 3, 0)
        end

        it 'returns a winner and not full board' do
          result = grid.check_connect_four(chip_p1)
          expect(result).to eq({ winner: true, full_board: false })
        end
      end

      context 'the grid if full and there in no winner' do
        before do
          allow(grid.board).to receive(:all?).and_return(true)
        end

        it 'returns no winner and full board' do
          result = grid.check_connect_four(chip_p1)
          expect(result).to eq({ winner: false, full_board: true })
        end
      end
    end
  end
end
