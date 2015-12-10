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

	describe "#remove_piece" do

		before :each do
			@chess.new_game
		end

		it "removes a piece in a given position" do
			@chess.remove_piece([:E,2])
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

	describe "#move_input" do

		before :each do
			@chess.new_game
			@white_queen = @chess.pieces.find { |piece| piece.color == :white && piece.type == :queen }
			@white_knight = @chess.pieces.find { |piece| piece.color == :white && piece.type == :knight && piece.position == [:G,1] }
			@black_pawn = @chess.pieces.find { |piece| piece.color == :black && piece.type == :pawn && piece.position == [:E,7] }
		end

		context "with valid move input" do

			before :each do
				expect(STDOUT).to receive(:puts).with("")
				expect(STDOUT).to receive(:puts).with("Choose the position of the piece you want to move:")
			end

			context "when move is possible" do

				before :each do
					expect(STDOUT).to receive(:puts).with("")
					expect(STDOUT).to receive(:puts).with("Choose which position to move your knight:")
				end

				it "moves the piece in the initial position to the new position" do
					@chess.move_input("G1","F3")
					expect(@white_knight.position).to eql [:F,3]
					occupied = @chess.gameboard.occupied_spaces
					search = @chess.pieces.find { |piece| piece.position == [:F,3] }
					expect(search).to be_truthy
					expect(occupied.find { |space| space == [:F,3] }).to be_truthy
					search = @chess.pieces.find { |piece| piece.position == [:G,1] }
					expect(search).to be_nil
					expect(occupied.find { |space| space == [:G,1] }).to be_nil
				end

			end

			context "when move is not possible" do

				before :each do
					expect(STDOUT).to receive(:puts).with("")
					expect(STDOUT).to receive(:puts).with("Choose which position to move your queen:")
				end

				it "gives an error message" do
					expect(STDOUT).to receive(:puts).with("")
					expect(STDOUT).to receive(:puts).with("Error: Invalid move! Try again...")
					expect(STDOUT).to receive(:puts).with("")
					@chess.move_input("D1","D4")
					expect(@white_queen.position).to eql [:D,1]
				end

			end

		end

		context "with " do
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
					expect(@chess.possible_moves(@white_king)).to be_empty
					expect(@chess.possible_moves(@white_queen)).to be_empty
				end
			end

			context "when not surrounded" do
				it "gives a hash of possible moves" do
					expect(@chess.possible_moves(@new_black_bishop)).to include([:D,4],[:E,5],[:F,6],
																																	 [:B,4],[:A,5],[:D,2],
																																	 [:B,2])
				end
			end

		end

		context "with a knight" do
			context "when completely surrounded by pieces of the same color" do
				it "gives a hash of possible moves" do
					expect(@chess.possible_moves(@white_knight)).to include([:H,3],[:F,3])
				end
			end
		end

		context "with a pawn" do

			context "when a piece is in front of it and nothing is diagonal" do
				it "gives a hash indicating no possible moves" do
					expect(@chess.possible_moves(@white_pawn_C)).to be_empty
				end
			end

			context "when no piece is in front of it and an opponent is diagonal" do
				it "gives a hash of possible moves" do
					expect(@chess.possible_moves(@white_pawn_B)).to include([:B,3],[:B,4],[:C,3])
				end
			end

		end

	end

	describe "#move_piece" do

		before :each do
			@chess.new_game
			@white_queen = @chess.pieces.find { |piece| piece.color == :white && piece.type == :queen }
			@white_knight = @chess.pieces.find { |piece| piece.color == :white && piece.type == :knight && piece.position == [:G,1] }
			@black_pawn = @chess.pieces.find { |piece| piece.color == :black && piece.type == :pawn && piece.position == [:E,7] }
		end

		context "when move is possible" do

			before :each do
				@chess.move_piece( @white_knight.position, [:F,3] )
			end

			it "moves the piece in the initial position to the new position" do
				expect(@white_knight.position).to eql [:F,3]
				occupied = @chess.gameboard.occupied_spaces
				search = @chess.pieces.find { |piece| piece.position == [:F,3] }
				expect(search).to be_truthy
				expect(occupied.find { |space| space == [:F,3] }).to be_truthy
				search = @chess.pieces.find { |piece| piece.position == [:G,1] }
				expect(search).to be_nil
				expect(occupied.find { |space| space == [:G,1] }).to be_nil
			end

			context "when new position is occupied by an opposing piece" do

				before :each do
					@chess.move_piece( @black_pawn.position, [:E,5] )
				end

				it "removes the opposing piece and replaces it with the moving piece" do
					expect(STDOUT).to receive(:puts).with("")
					expect(STDOUT).to receive(:puts).with("A black pawn has been captured!")
					expect(STDOUT).to receive(:puts).with("")
					@chess.move_piece( @white_knight.position, @black_pawn.position )
					expect(@chess.pieces.count(@black_pawn)).to eql 0
					expect(@white_knight.position).to eql [:E,5]
					occupied = @chess.gameboard.occupied_spaces
					search = @chess.pieces.find { |piece| piece.position == [:E,5] }
					expect(search).to be_truthy
					expect(occupied.find { |space| space == [:E,5] }).to be_truthy
					expect(occupied.count([:E,5])).to eql 1
					search = @chess.pieces.find { |piece| piece.position == [:F,3] }
					expect(search).to be_nil
					expect(occupied.find { |space| space == [:F,3] }).to be_nil
				end

			end

		end

		context "when move is not possible" do

			before :each do
				@move = @chess.move_piece( @white_queen.position, [:D,3] )
			end

			it "returns an invalid_move symbol" do
				expect(@move).to eql :invalid_move
			end

		end

	end

end