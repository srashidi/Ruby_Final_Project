require './gameboard'
require './piece'

class Chess

	A = 2
	B = 7
	C = 12
	D = 17
	E = 22
	F = 27
	G = 32
	H = 37

	def initialize
	end

	# Creates a new game of chess with a gameboard and pieces occupying spaces
	def new_game
		@gameboard = Gameboard.new
		@pieces = [
			Piece.new(:king,:white,[:E,1]), Piece.new(:queen,:white,[:D,1]),
			Piece.new(:rook,:white,[:H,1]), Piece.new(:rook,:white,[:A,1]),
			Piece.new(:knight,:white,[:G,1]), Piece.new(:knight,:white,[:B,1]),
			Piece.new(:bishop,:white,[:F,1]), Piece.new(:bishop,:white,[:C,1]),
			Piece.new(:pawn,:white,[:A,2]), Piece.new(:pawn,:white,[:B,2]),
			Piece.new(:pawn,:white,[:C,2]), Piece.new(:pawn,:white,[:D,2]),
			Piece.new(:pawn,:white,[:E,2]), Piece.new(:pawn,:white,[:F,2]),
			Piece.new(:pawn,:white,[:G,2]), Piece.new(:pawn,:white,[:H,2]),
			Piece.new(:king,:black,[:E,8]), Piece.new(:queen,:black,[:D,8]),
			Piece.new(:rook,:black,[:H,8]), Piece.new(:rook,:black,[:A,8]),
			Piece.new(:knight,:black,[:G,8]), Piece.new(:knight,:black,[:B,8]),
			Piece.new(:bishop,:black,[:F,8]), Piece.new(:bishop,:black,[:C,8]),
			Piece.new(:pawn,:black,[:A,7]),Piece.new(:pawn,:black,[:B,7]),
			Piece.new(:pawn,:black,[:C,7]), Piece.new(:pawn,:black,[:D,7]),
			Piece.new(:pawn,:black,[:E,7]), Piece.new(:pawn,:black,[:F,7]),
			Piece.new(:pawn,:black,[:G,7]), Piece.new(:pawn,:black,[:H,7])
			]
		@pieces.each do |piece|
			@gameboard.occupied_spaces << piece.position
		end
	end

	# Displays the current gameboard and pieces
	def display

		row1 = "|    |    |    |    |    |    |    |    |"
		row2 = "|    |    |    |    |    |    |    |    |"
		row3 = "|    |    |    |    |    |    |    |    |"
		row4 = "|    |    |    |    |    |    |    |    |"
		row5 = "|    |    |    |    |    |    |    |    |"
		row6 = "|    |    |    |    |    |    |    |    |"
		row7 = "|    |    |    |    |    |    |    |    |"
		row8 = "|    |    |    |    |    |    |    |    |"

		def line
			"_________________________________________"
		end

		@pieces.each do |piece|
			row = case piece.position[1]
			when 1 then row1
			when 2 then row2
			when 3 then row3
			when 4 then row4
			when 5 then row5
			when 6 then row6
			when 7 then row7
			when 8 then row8
			end
			column = case piece.position[0]
			when :A then A
			when :B then B
			when :C then C
			when :D then D
			when :E then E
			when :F then F
			when :G then G
			when :H then H
			end
			row[column] = piece.view
		end

		puts line
		puts row1
		puts line
		puts row2
		puts line
		puts row3
		puts line
		puts row4
		puts line
		puts row5
		puts line
		puts row6
		puts line
		puts row7
		puts line
		puts row8
		puts line

	end

	# Removes a piece in the given position from the gameboard
	def remove(position)
		@pieces.delete_if { |piece| piece.position == position }
		@gameboard.occupied_spaces.delete_if { |space| space == position }
	end

end