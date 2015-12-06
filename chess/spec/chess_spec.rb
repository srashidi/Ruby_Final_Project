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
			@white_knight = @chess.pieces.find { |piece| piece.color == :white && piece.type == :knight && piece.position == [:G,1] }
			@white_pawn_B = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:B,2] }
			@white_pawn_C = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:C,2] }
			@chess.pieces << Piece.new(:bishop,:black,[:C,3],true)
			@new_black_bishop = @chess.pieces[-1]
			@chess.gameboard.occupied_spaces << [:C,3]
		end

		context "with a piece that jumps from spaces to space (king, queen, rook, bishop)" do

			context "when completely surrounded by pieces of the same color" do
				it "gives a hash indicating no possible moves" do
					expect(@chess.possible_moves(@white_king)).to eql ({ east: [], northeast: [],
																								north: [], northwest: [],
																								west: [], southwest: [],
																								south: [], southeast: [] })
					expect(@chess.possible_moves(@white_queen)).to eql ({ east: [], northeast: [],
																								north: [], northwest: [],
																								west: [], southwest: [],
																								south: [], southeast: [] })
				end
			end

			context "when not surrounded" do
				it "gives a hash of possible moves" do
					expect(@chess.possible_moves(@new_black_bishop)).to eql({northeast: [[:D,4],[:E,5],[:F,6]],
																																	 northwest: [[:B,4],[:A,5]],
																																	 southeast: [[:D,2]],
																																	 southwest: [[:B,2]]})
				end
			end

		end

		context "with a knight" do
			context "when completely surrounded by pieces of the same color" do
				it "gives a hash of possible moves" do
					expect(@chess.possible_moves(@white_knight)).to eql({northeast: [[:H,3]], northwest: [[:F,3]],
																															 eastnorth: [], westnorth: [],
																															 southeast: [], southwest: [],
																															 eastsouth: [], westsouth: [] })
				end
			end
		end

		context "with a pawn" do

			context "when a piece is in front of it and nothing is diagonal" do
				it "gives a hash indicating no possible moves" do
					expect(@chess.possible_moves(@white_pawn_C)).to eql({	forward: [],
																																twiceforward: [],
																																diagonalwest: [],
																																diagonaleast: [] })
				end
			end

			context "when no piece is in front of it and an opponent is diagonal" do
				it "gives a hash of possible moves" do
					expect(@chess.possible_moves(@white_pawn_B)).to eql({	forward: [[:B,3]],
																																twiceforward: [[:B,4]],
																																diagonalwest: [],
																																diagonaleast: [[:C,3]] })
				end
			end

		end

	end



end