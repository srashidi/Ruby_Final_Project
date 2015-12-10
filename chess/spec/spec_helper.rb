require_relative '../chess'
require_relative '../gameboard'
require_relative '../piece'

class Chess

	attr_reader :test_mode, :gameboard, :pieces

	def initialize(test_mode)
		@test_mode = test_mode
	end

	def move_input(initial_position,new_position,color)
		puts ""
		puts "Choose the position of the piece you want to move:"
		initial_position = initial_position.upcase.gsub(/\s+/,"").split("")
		initial_position = [initial_position[0].to_sym,initial_position[1].to_i]
		piece = @pieces.find { |current_piece| current_piece.position == initial_position }
		if piece != nil && piece.color == color
			puts ""
			puts "Choose which position to move your #{piece.type}:"
			new_position = new_position.upcase.gsub(/\s+/,"").split("")
			new_position = [new_position[0].to_sym,new_position[1].to_i]
			move = move_piece(initial_position,new_position)
		else
			move = :invalid_move
		end
		if move == :invalid_move
			puts ""
			puts "Error: Invalid move! Try again..."
			puts ""
		end
	end

end