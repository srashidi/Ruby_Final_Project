require 'spec_helper'

describe Piece do

	before :each do
		@king = Piece.new(:king,:white,[:E,1])
	end

	describe "#new" do

		it "takes three parameters and returns a Piece object" do
			expect(@king).to be_an_instance_of Piece
		end

	end

	describe "#type" do

		it "returns the correct type" do
			expect(@king.type).to eql :king
		end

	end

	describe "#color" do

		it "returns the correct color" do
			expect(@king.color).to eql :white
		end

	end

	describe "#position" do

		it "returns the current position" do
			expect(@king.position).to eql [:E,1]
		end

		it "can be set to a new position" do
			@king.position = [:E,2]
			expect(@king.position).to eql [:E,2]
		end

	end

	describe "#view" do

		it "returns the correct unicode view" do
			expect(@king.view).to eql "\u{2654}"
		end

	end

	describe "#possible_moves" do

		before :each do
			@queen = Piece.new(:queen,:white,[:D,1])
			@bishop = Piece.new(:bishop,:white,[:C,1])
			@knight = Piece.new(:knight,:white,[:B,1])
			@rook = Piece.new(:rook,:white,[:A,1])
			@white_pawn = Piece.new(:pawn,:white,[:H,2])
			@black_pawn = Piece.new(:pawn,:black,[:B,6],true)
		end

		context "when #type is :king" do
			it "gives a hash of all possible moves" do
				expect(@king.possible_moves).to eql({ east: [[:F,1]], northeast: [[:F,2]],
																							north: [[:E,2]], northwest: [[:D,2]],
																							west: [[:D,1]], southwest: [],
																							south: [], southeast: [] })
			end
		end

		context "when #type is :queen" do
			it "gives a hash of all possible moves" do
				expect(@queen.possible_moves).to eql({east: [[:E,1],[:F,1],[:G,1],[:H,1]],
																							northeast: [[:E,2],[:F,3],[:G,4],[:H,5]],
																							north: [[:D,2],[:D,3],[:D,4],[:D,5],
																											[:D,6],[:D,7],[:D,8]],
																							northwest: [[:C,2],[:B,3],[:A,4]],
																							west: [[:C,1],[:B,1],[:A,1]],
																							southwest: [], south: [], southeast: [] })
			end
		end

		context "when #type is :bishop" do
			it "gives a hash of all possible moves" do
				expect(@bishop.possible_moves).to eql({northeast: [[:D,2],[:E,3],[:F,4],
																													 [:G,5],[:H,6]],
																							 northwest: [[:B,2],[:A,3]],
																							 southwest: [], southeast: [] })
			end
		end

		context "when #type is :knight" do
			it "gives a hash of all possible moves" do
				expect(@knight.possible_moves).to eql({northeast: [[:C,3]], northwest: [[:A,3]],
																							 eastnorth: [[:D,2]], westnorth: [],
																							 southeast: [], southwest: [],
																							 eastsouth: [], westsouth: [] })
			end
		end

		context "when #type is :rook" do
			it "gives a hash of all possible moves" do
				expect(@rook.possible_moves).to eql({	east: [[:B,1],[:C,1],[:D,1],[:E,1],
																										 [:F,1],[:G,1],[:H,1]],
																							north: [[:A,2],[:A,3],[:A,4],[:A,5],
																											[:A,6],[:A,7],[:A,8]],
																							west: [],
																							south: [] })
			end
		end

		context "when #type is :pawn" do

			context "when #color is :white" do
				context "when pawn has not moved" do
					it "gives a hash of all possible moves" do
						expect(@white_pawn.possible_moves).to eql({	forward: [[:H,3]],
																												twiceforward: [[:H,4]],
																												diagonalwest: [[:G,3]],
																												diagonaleast: [] })
					end
				end
			end

			context "when #color is :black" do
				context "when pawn has moved" do
					it "gives a hash of all possible moves" do
						expect(@black_pawn.possible_moves).to eql({	forward: [[:B,5]],
																												twiceforward: [],
																												diagonaleast: [[:C,5]],
																												diagonalwest: [[:A,5]] })
					end
				end
			end

		end

	end

end