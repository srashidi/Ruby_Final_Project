require_relative '../lib/chess'
require_relative '../lib/game_menu'
require_relative '../lib/gameboard'
require_relative '../lib/piece'

class Chess

	attr_reader :test_mode, :gameboard, :pieces

	def initialize(test_mode)
		@test_mode = test_mode
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

	# Initiates move input
	def move_input(initial_position,new_position,color,*new_input)
		initial_position_input(initial_position,new_position,color,new_input)
	end

	# Takes user input for the initial position
	def initial_position_input(initial_position,new_position,color,*new_input)
		puts ""
		puts "Choose the position of the piece you want to move:"
		initial_position = initial_position.upcase.gsub(/\s+/,"")
		move = case initial_position
		when "HELP"
			:help
		when "SAVE"
			:save
		when "EXIT"
			:exit
		when "CASTLE"
			castle(color)
		else
			initial_position = initial_position.split("")
			initial_position = [initial_position[0].to_sym,initial_position[1].to_i]
			piece = @pieces.find { |current_piece| current_piece.position == initial_position }
			if piece != nil && piece.color == color && possible_moves(piece) != []
				move = new_position_input(initial_position,new_position,color,piece,new_input[0])
			else
				move = :invalid_move
			end
		end
		move
	end

	# Take user input for the new position
	def new_position_input(initial_position,new_position,color,piece,*new_input)
		puts ""
		puts "Choose which position to move your #{piece.type},"
		puts "or choose a different piece by inputting its position:"
		new_position = new_position.upcase.gsub(/\s+/,"")
		move = case initial_position
		when "HELP"
			:help
		when "SAVE"
			:save
		when "EXIT"
			:exit
		else
			new_position = new_position.split("")
			new_position = [new_position[0].to_sym,new_position[1].to_i]
			current_piece = @pieces.find { |piece| piece.position == initial_position }
			new_piece = @pieces.find { |piece| piece.position == new_position }
			if new_piece != nil && new_piece.color == color && possible_moves(new_piece) != []
				new_position_input(new_position,new_input.flatten[0],color,new_piece)
			else
				if king_status(color) == :check
					status = temporary_move(current_piece,new_position)
					if status == :safe
						move = move_piece(initial_position,new_position)
					else
						move = :unsafe
					end
				else
					move = move_piece(initial_position,new_position)
				end
			end
		end
		move
	end

end

class GameMenu

	# Allows user to choose to start a new game, load a saved game, or exit
	def initialize(input,*new_input)
		puts ""
		puts "Choose from the following options (input \"1\",\"2\", or \"3\"):"
		puts "1: Start a new game"
		puts "2: Load a saved game"
		puts "3: Exit"
		choice = input.strip.to_i
		puts ""
		case choice
		when 1
			Chess.new
			initialize(new_input)
		when 2
			load_game
			initialize(new_input)
		when 3
			puts "Goodbye!"
		else
			puts "Error: Invalid input! Try again..."
			initialize(new_input)
		end
	end

end