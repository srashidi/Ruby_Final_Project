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

	describe "#possible_moves" do

		before :each do

		end

	end



end