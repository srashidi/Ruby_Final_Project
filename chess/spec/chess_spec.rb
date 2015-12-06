require 'spec_helper'

describe Chess do

	before :each do
		@chess = Chess.new(:test_mode)
	end

	it "returns a Chess object" do
		expect(@chess).to be_an_instance_of Chess
	end

	describe "#new_game" do

		before :each do
			@chess.new_game
		end

		it "creates a new Gameboard object" do
			expect(@chess.gameboard).to be_an_instance_of Gameboard
		end

		it "creates an array of Piece objects" do
			@chess.pieces.each do |piece|
				expect(piece).to be_an_instance_of Piece
			end
		end

		it "fills the gameboard's occupied_spaces array with
	each piece's position" do
			@chess.gameboard.occupied_spaces.each_with_index do |space,index|
				expect(space).to eql @chess.pieces[index].position
			end
		end

	end

	describe "#remove" do

		before :each do
			@chess.new_game
		end

		it "removes a piece in a given position" do
			@chess.remove([:E,2])
			occupied = @chess.gameboard.occupied_spaces
			search = @chess.pieces.find { |piece| piece.position == [:E,1] }
			expect(search).to be_truthy
			expect(occupied.find { |space| space == [:E,1] }).to be_truthy
			search = @chess.pieces.find { |piece| piece.position == [:E,2] }
			expect(search).to be_nil
			expect(occupied.find { |space| space == [:E,2] }).to be_nil
		end

	end

	describe "#display" do

		before :each do
			@chess.new_game
		end

		it "shows the gameboard and the pieces in correct positions" do
			white_king = "\u{2654}"
			white_queen = "\u{2655}"
			white_bishop = "\u{2657}"
			white_knight = "\u{2658}"
			white_rook = "\u{2656}"
			white_pawn = "\u{2659}"
			black_king = "\u{265A}"
			black_queen = "\u{265B}"
			black_bishop = "\u{265D}"
			black_knight = "\u{265E}"
			black_rook = "\u{265C}"
			black_pawn = "\u{265F}"
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			expect(STDOUT).to receive(:puts).with("| #{black_rook}  | #{black_knight}  | #{black_bishop}  | #{black_queen}  | #{black_king}  | #{black_bishop}  | #{black_knight}  | #{black_rook}  |")
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			expect(STDOUT).to receive(:puts).with("| #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  |")
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			expect(STDOUT).to receive(:puts).with("|    |    |    |    |    |    |    |    |")
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			expect(STDOUT).to receive(:puts).with("|    |    |    |    |    |    |    |    |")
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			expect(STDOUT).to receive(:puts).with("|    |    |    |    |    |    |    |    |")
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			expect(STDOUT).to receive(:puts).with("|    |    |    |    |    |    |    |    |")
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			expect(STDOUT).to receive(:puts).with("| #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  |")
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			expect(STDOUT).to receive(:puts).with("| #{white_rook}  | #{white_knight}  | #{white_bishop}  | #{white_queen}  | #{white_king}  | #{white_bishop}  | #{white_knight}  | #{white_rook}  |")
			expect(STDOUT).to receive(:puts).with("_________________________________________")
			@chess.display
		end

	end

	describe "#possible_moves" do

		before :each do
			@chess.new_game
			@white_king = @chess.pieces.find { |piece| piece.color == :white && piece.type == :king }
			@white_queen = @chess.pieces.find { |piece| piece.color == :white && piece.type == :queen }
			@white_knight = @chess.pieces.find { |piece| piece.color == :white && piece.type == :knight }

		end



	end



end