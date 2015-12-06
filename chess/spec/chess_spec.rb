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

	describe "#possible_moves" do

		before :each do

		end

	end

end