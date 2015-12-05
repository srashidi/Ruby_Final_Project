require 'spec_helper'

describe Chess do

	before :each do
		@chess = Chess.new
	end

	it "returns a Chess object" do
		expect(@chess).to be_an_instance_of Chess
	end

	describe "#new_game" do

		before :each do
			@game = @chess.new_game
		end

		it "creates a new Gameboard object" do
			expect(@chess.gameboard).to be_an_instance_of Gameboard
		end

		it "creates an array of Piece objects" do
			i = 0
			31.times do
				expect(@chess.pieces[i]).to be_an_instance_of Piece
				i += 1
			end
		end

		it "fills the gameboard's occupied_spaces array with
	each piece's position" do
			i = 0
			31.times do
				expect(@chess.gameboard.occupied_spaces[i]).to eql @chess.pieces[i].position
				i += 1
			end
		end

	end

end