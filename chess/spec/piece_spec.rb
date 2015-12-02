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
			@pawn = Piece.new(:pawn,:white,[:H,2])
		end

		it "gives an array of all possible moves" do
		end

	end

end