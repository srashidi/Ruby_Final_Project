require './gameboard'
require './piece'

class Chess

	def initialize
	end

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

end