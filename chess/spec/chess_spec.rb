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

	describe "#castle" do

		before :each do
			@chess.new_game
			@white_king = @chess.pieces.find { |piece| piece.color == :white && piece.type == :king }
			@white_rook_A = @chess.pieces.find { |piece| piece.color == :white && piece.type == :rook && piece.position == [:A,1] }
			@white_rook_H = @chess.pieces.find { |piece| piece.color == :white && piece.type == :rook && piece.position == [:H,1] }
			@white_queen = @chess.pieces.find { |piece| piece.color == :white && piece.type == :queen }
			@white_knight_B = @chess.pieces.find { |piece| piece.color == :white && piece.type == :knight && piece.position == [:B,1] }
			@white_knight_G = @chess.pieces.find { |piece| piece.color == :white && piece.type == :knight && piece.position == [:G,1] }
			@white_bishop_C = @chess.pieces.find { |piece| piece.color == :white && piece.type == :bishop && piece.position == [:C,1] }
			@white_bishop_F = @chess.pieces.find { |piece| piece.color == :white && piece.type == :bishop && piece.position == [:F,1] }
			@white_pawn_B = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:B,2] }
			@white_pawn_C = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:C,2] }
			@white_pawn_E = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:E,2] }
			@chess.move_piece( @white_pawn_B.position,[:B,4] )
			@chess.move_piece( @white_pawn_C.position,[:C,4] )
			@chess.move_piece( @white_pawn_E.position,[:E,4] )
			@chess.move_piece( @white_queen.position,[:A,4] )
			@chess.move_piece( @white_bishop_C.position,[:B,2] )
			@chess.move_piece( @white_bishop_F.position,[:E,2] )
		end

		context "when rooks and king have not moved" do

			context "when no castle is possible" do
				it "returns an invalid move symbol" do
					move = @chess.castle(:white)
					expect(move).to eql :invalid_move
					expect(@white_king.position).to eql [:E,1]
					expect(@white_rook_H.position).to eql [:H,1]
					expect(@white_rook_A.position).to eql [:A,1]
				end
			end

			context "when castle with only A-side rook is possible" do

				before :each do
					@chess.move_piece( @white_knight_B.position, [:A,3] )
					@chess.castle(:white)
				end

				it "performs that castle" do
					expect(@white_king.position).to eql [:C,1]
					expect(@white_rook_A.position).to eql [:D,1]
					expect(@white_rook_H.position).to eql [:H,1]
				end

			end

			context "when castle with only H-side rook is possible" do

				before :each do
					@chess.move_piece( @white_knight_G.position, [:H,3] )
					@chess.castle(:white)
				end

				it "performs that castle" do
					expect(@white_king.position).to eql [:G,1]
					expect(@white_rook_H.position).to eql [:F,1]
					expect(@white_rook_A.position).to eql [:A,1]
				end

			end

			context "when castle with either rook is possible" do

				before :each do
					@chess.move_piece( @white_knight_B.position, [:A,3] )
					@chess.move_piece( @white_knight_G.position, [:H,3] )
				end

				context "when the A-side rook is chosen" do
					it "performs that castle" do
						@chess.castle(:white,:A)
						expect(@white_king.position).to eql [:C,1]
						expect(@white_rook_A.position).to eql [:D,1]
						expect(@white_rook_H.position).to eql [:H,1]
					end
				end

				context "when the H-side rook is chosen" do
					it "performs that castle" do
						@chess.castle(:white,:H)
						expect(@white_king.position).to eql [:G,1]
						expect(@white_rook_H.position).to eql [:F,1]
						expect(@white_rook_A.position).to eql [:A,1]
					end
				end

			end

		end

		context "when rooks or king have moved" do

			context "when A-side rook has moved" do

				before :each do
					@chess.move_piece( @white_knight_B.position, [:A,3] )
					@chess.move_piece( @white_rook_A.position, [:B,1] )
				end

				context "when castle with H-side rook is not possible" do
					it "returns an invalid move symbol" do
						move = @chess.castle(:white)
						expect(move).to eql :invalid_move
						expect(@white_king.position).to eql [:E,1]
						expect(@white_rook_H.position).to eql [:H,1]
						expect(@white_rook_A.position).to eql [:B,1]
					end
				end

				context "when castle with H-side rook is possible" do

					before :each do
						@chess.move_piece( @white_knight_G.position, [:H,3] )
						@chess.castle(:white)
					end

					it "performs that castle" do
						expect(@white_king.position).to eql [:G,1]
						expect(@white_rook_H.position).to eql [:F,1]
						expect(@white_rook_A.position).to eql [:B,1]
					end

				end

			end

			context "when both rooks have been moved" do

				before :each do
					@chess.move_piece( @white_knight_B.position, [:A,3] )
					@chess.move_piece( @white_rook_A.position, [:B,1] )
					@chess.move_piece( @white_knight_G.position, [:H,3] )
					@chess.move_piece( @white_rook_H.position, [:G,1] )
				end

				it "returns an invalid move symbol" do
					move = @chess.castle(:white)
					expect(move).to eql :invalid_move
					expect(@white_king.position).to eql [:E,1]
					expect(@white_rook_H.position).to eql [:G,1]
					expect(@white_rook_A.position).to eql [:B,1]
				end

			end

			context "when the king has been moved" do

				before :each do
					@chess.move_piece( @white_knight_B.position, [:A,3] )
					@chess.move_piece( @white_knight_G.position, [:H,3] )
					@chess.move_piece( @white_king.position, [:D,1] )
				end

				it "returns an invalid move symbol" do
					move = @chess.castle(:white)
					expect(move).to eql :invalid_move
					expect(@white_king.position).to eql [:D,1]
					expect(@white_rook_H.position).to eql [:H,1]
					expect(@white_rook_A.position).to eql [:A,1]
				end

			end

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
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("8 | #{black_rook}  | #{black_knight}  | #{black_bishop}  | #{black_queen}  | #{black_king}  | #{black_bishop}  | #{black_knight}  | #{black_rook}  |")
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("7 | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  | #{black_pawn}  |")
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("6 |    |    |    |    |    |    |    |    |")
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("5 |    |    |    |    |    |    |    |    |")
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("4 |    |    |    |    |    |    |    |    |")
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("3 |    |    |    |    |    |    |    |    |")
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("2 | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  | #{white_pawn}  |")
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("1 | #{white_rook}  | #{white_knight}  | #{white_bishop}  | #{white_queen}  | #{white_king}  | #{white_bishop}  | #{white_knight}  | #{white_rook}  |")
			expect(STDOUT).to receive(:puts).with("  _________________________________________")
			expect(STDOUT).to receive(:puts).with("    A    B    C    D     E    F    G    H  ")
			@chess.display
		end

	end

	describe "#move_input" do

		before :each do
			@chess.new_game
			@white_queen = @chess.pieces.find { |piece| piece.color == :white && piece.type == :queen }
			@white_knight = @chess.pieces.find { |piece| piece.color == :white && piece.type == :knight && piece.position == [:G,1] }
			@black_knight = @chess.pieces.find { |piece| piece.color == :black && piece.type == :knight && piece.position == [:G,8] }
			@white_pawn = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:E,2] }
			@white_pawn_F = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:F,2] }
			@black_pawn = @chess.pieces.find { |piece| piece.color == :black && piece.type == :pawn && piece.position == [:E,7] }
			@black_pawn_D = @chess.pieces.find { |piece| piece.color == :black && piece.type == :pawn && piece.position == [:D,7] }
			@white_bishop = @chess.pieces.find { |piece| piece.color == :white && piece.type == :bishop && piece.position == [:F,1] }
			@black_bishop = @chess.pieces.find { |piece| piece.color == :black && piece.type == :bishop && piece.position == [:F,8] }
			expect(STDOUT).to receive(:puts).with("")
			expect(STDOUT).to receive(:puts).with("Choose the position of the piece you want to move:")
		end

		context "with valid move input" do

			context "when move is possible" do

				it "moves the piece in the initial position to the new position" do
					expect(STDOUT).to receive(:puts).with("")
					expect(STDOUT).to receive(:puts).with("Choose which position to move your knight,")
					expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
					@chess.move_input("G1","F3",:white)
					expect(@white_knight.position).to eql [:F,3]
					occupied = @chess.gameboard.occupied_spaces
					search = @chess.pieces.find { |piece| piece.position == [:F,3] }
					expect(search).to be_truthy
					expect(occupied.find { |space| space == [:F,3] }).to be_truthy
					search = @chess.pieces.find { |piece| piece.position == [:G,1] }
					expect(search).to be_nil
					expect(occupied.find { |space| space == [:G,1] }).to be_nil
				end

				context "when input includes whitespace" do

					it "moves the piece in the initial position to the new position" do
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose which position to move your knight,")
						expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
						@chess.move_input("G 1"," F3",:white)
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

				context "when input has lowercase letters instead of uppercase letters" do

					it "moves the piece in the initial position to the new position" do
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose which position to move your knight,")
						expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
						@chess.move_input("g1","f3",:white)
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

				context "when player is in check" do

					before :each do
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose which position to move your pawn,")
						expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
						@chess.move_input("E2","E3",:white)
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose the position of the piece you want to move:")
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose which position to move your pawn,")
						expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
						@chess.move_input("D7","D5",:black)
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose the position of the piece you want to move:")
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose which position to move your bishop,")
						expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
						@chess.move_input("F1","B5",:white)
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose the position of the piece you want to move:")
						expect(STDOUT).to receive(:puts).with("")
						expect(STDOUT).to receive(:puts).with("Choose which position to move your bishop,")
						expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
					end

					it "takes the player out of check" do
						@chess.move_input("C8","D7",:black)
						expect(@chess.king_status(:black)).not_to eql :check
					end

				end

			end

			context "when a different piece is chosen to move" do

				it "moves that piece instead" do
					expect(STDOUT).to receive(:puts).with("")
					expect(STDOUT).to receive(:puts).with("Choose which position to move your knight,")
					expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
					expect(STDOUT).to receive(:puts).with("")
					expect(STDOUT).to receive(:puts).with("Choose which position to move your pawn,")
					expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
					@chess.move_input("G1","F2",:white,"F3")
					expect(@white_knight.position).to eql [:G,1]
					expect(@white_pawn_F.position).to eql [:F,3]
					occupied = @chess.gameboard.occupied_spaces
					search = @chess.pieces.find { |piece| piece.position == [:G,1] }
					expect(search).to be_truthy
					expect(occupied.find { |space| space == [:G,1] }).to be_truthy
					search = @chess.pieces.find { |piece| piece.position == [:F,3] }
					expect(search).to be_truthy
					expect(occupied.find { |space| space == [:F,3] }).to be_truthy
					search = @chess.pieces.find { |piece| piece.position == [:F,2] }
					expect(search).to be_nil
					expect(occupied.find { |space| space == [:F,2] }).to be_nil
				end

			end

			context "when move is not possible" do

				context "when choosing a piece of the correct color" do

					it "returns an error symbol" do
						move = @chess.move_input("D1","D4",:white)
						expect(@white_queen.position).to eql [:D,1]
						expect(move).to eql :invalid_move
					end

				end

				context "when choosing a piece of the incorrect color" do

					it "returns an error symbol" do
						move = @chess.move_input("E7","E6",:white)
						expect(@black_pawn.position).to eql [:E,7]
						expect(move).to eql :invalid_move
					end

				end

			end


		end

		context "with invalid move input" do

			context "for the initial position" do

				it "returns an error symbol" do
					move = @chess.move_input("1G","F3",:white)
					expect(@white_knight.position).to eql [:G,1]
					expect(move).to eql :invalid_move
				end

			end

			context "for the new position" do

				before :each do
					expect(STDOUT).to receive(:puts).with("")
					expect(STDOUT).to receive(:puts).with("Choose which position to move your knight,")
					expect(STDOUT).to receive(:puts).with("or choose a different piece by inputting its position:")
				end

				it "returns an error symbol" do
					move = @chess.move_input("G1","3F",:white)
					expect(@white_knight.position).to eql [:G,1]
					expect(move).to eql :invalid_move
				end


			end

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

	describe "#king_status" do

		before :each do
			@chess.new_game
			@white_queen = @chess.pieces.find { |piece| piece.color == :white && piece.type == :queen }
			@black_king = @chess.pieces.find { |piece| piece.color == :black && piece.type == :king }
			@white_knight = @chess.pieces.find { |piece| piece.color == :white && piece.type == :knight && piece.position == [:G,1] }
			@black_knight = @chess.pieces.find { |piece| piece.color == :black && piece.type == :knight && piece.position == [:G,8] }
			@white_pawn = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:E,2] }
			@white_pawn_F = @chess.pieces.find { |piece| piece.color == :white && piece.type == :pawn && piece.position == [:F,2] }
			@black_pawn = @chess.pieces.find { |piece| piece.color == :black && piece.type == :pawn && piece.position == [:E,7] }
			@white_bishop = @chess.pieces.find { |piece| piece.color == :white && piece.type == :bishop && piece.position == [:F,1] }
			@black_bishop = @chess.pieces.find { |piece| piece.color == :black && piece.type == :bishop && piece.position == [:F,8] }
			@chess.move_piece( @white_pawn.position, [:E,4] )
			@chess.move_piece( @black_pawn.position, [:E,6] )
			@chess.move_piece( @white_queen.position, [:G,4] )
			@chess.move_piece( @black_knight.position, [:F,6] )
			@chess.move_piece( @white_queen.position, [:F,4] )
			@chess.move_piece( @black_pawn.position, [:E,5] )
		end

		context "when king is in check" do

			before :each do
				@chess.move_piece( @white_queen.position, [:E,5] )
			end

			it "returns a check status symbol" do
				expect(@chess.king_status(:black)).to eql :check
			end

		end

		context "when king is not in check" do

			it "returns a safe status symbol" do
				expect(@chess.king_status(:black)).to eql :safe
			end

		end

		context "when king is in checkmate" do

			before :each do
				@chess.move_piece( @white_queen.position, [:E,5] )
				@chess.move_piece( @black_bishop.position, [:E,7] )
				@chess.move_piece( @white_queen.position, [:G,5] )
				@chess.move_piece( @black_knight.position, [:E,4] )
				@chess.move_piece( @white_queen.position, [:G,7] )
				@chess.move_piece( @black_knight.position, [:D,6] )
				@chess.move_piece( @white_queen.position, [:H,8] )
				@chess.move_piece( @black_bishop.position, [:F,8] )
				@chess.move_piece( @white_knight.position, [:F,3] )
				@chess.move_piece( @black_knight.position, [:F,5] )
				@chess.move_piece( @white_knight.position, [:G,5] )
				@chess.move_piece( @black_bishop.position, [:G,7] )
				@chess.move_piece( @white_queen.position, [:G,7] )
				@chess.move_piece( @black_knight.position, [:D,4] )
				@chess.move_piece( @white_knight.position, [:F,7] )
				@chess.move_piece( @black_knight.position, [:F,3] )
				@chess.move_piece( @white_bishop.position, [:C,4] )
				@chess.move_piece( @black_king.position, [:E,7] )
				@chess.move_piece( @white_queen.position, [:H,7] )
				@chess.move_piece( @black_knight.position, [:D,4] )
				@chess.move_piece( @white_knight.position, [:G,5] )
				@chess.move_piece( @black_king.position, [:F,6] )
				@chess.move_piece( @white_queen.position, [:F,7] )
				@chess.move_piece( @black_king.position, [:E,5] )
				@chess.move_piece( @white_pawn_F.position, [:F,4] )
				@chess.move_piece( @black_king.position, [:D,6] )
				@chess.move_piece( @white_knight.position, [:E,4] )
				@chess.move_piece( @black_king.position, [:C,6] )
				@chess.move_piece( @white_queen.position, [:D,5] )
				@chess.move_piece( @black_king.position, [:B,6] )
				@chess.move_piece( @white_queen.position, [:C,5] )
			end

			it "returns a check status symbol" do
				expect(@chess.king_status(:black)).to eql :checkmate
			end

		end

	end

end