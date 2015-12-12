require_relative './gameboard'
require_relative './piece'

require 'yaml'
require 'launchy'

class Chess

	# Position for each column in the string
	A = 2
	B = 7
	C = 12
	D = 17
	E = 22
	F = 27
	G = 32
	H = 37

	# Initializes new game or saved game
	def initialize(*saved_info)
		if saved_info.empty?
			new_game
		else
			load_game(saved_info)
		end
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
		puts "You have started a new game of chess!"
		puts "Each player will take turns, starting with"
		puts "white, and whoever can put the other"
		puts "player's king in checkmate wins!"
		gameplay_options
		turn(:white)
	end

	def load_game(saved_info)
		@gameboard = saved_info[0]
		@pieces = saved_info[1]
		gameplay_options
		turn(saved_info[2])
	end

	def gameplay_options
		puts ""
		puts "When inputting a position on the board, type the letter"
		puts "of the coordinate first, then the number (ex, \"B5\")."
		puts "You can also \"castle\" if possible."
		puts "During the game, you can \"save\" your game and exit,"
		puts "\"exit\" to menu without saving, or ask for \"help\"."
		puts ""
		puts "Press ENTER when you are ready to continue."
		gets
	end

	def save_game(player_color)
		File.open("saved_games.yaml", "a") do |out|
      YAML::dump([@gameboard,@pieces,player_color,Time.now], out)
    end
	end

	def help
		Launchy.open("https://en.wikipedia.org/wiki/Chess#Rules")
		puts ""
		puts "An explanation of the rules of chess has been opened on"
		puts "your default browser."
		gameplay_options
	end

	def turn(player_color,type=nil)
		opponent_color = :black if player_color == :white
		opponent_color = :white if player_color == :black
		end_row = case opponent_color
		when :white
			8
		when :black
			1
		end
		pawn = @pieces.find { |piece| piece.type == :pawn && piece.position[1] == end_row}
		promoted = promotion(pawn) unless pawn.nil?
		puts ""
		display
		if type == :queen || type == :bishop || type == :knight || type == :rook || type == :pawn
			puts ""
			string = type == :queen ? "The " : "A "
			puts string + "#{player_color} #{type} has been captured!"
		end
		if promoted
			puts ""
			puts "A #{opponent_color} pawn has been promoted to a queen!"
		end
		if king_status(player_color) == :checkmate
			checkmate_message(player_color)
			play_again
		else
			puts ""
			puts "#{player_color.to_s.capitalize}'s turn!"
			check_message(player_color) if king_status(player_color) == :check
			move = move_input(player_color)
			puts ""
			case move
			when :help
				help
				turn(player_color)
			when :save
				save_game(player_color)
				puts "Game saved!"
				puts ""
			when :exit
				puts ""
			when :unsafe
				puts "Danger: This move will cause your king to be in check!"
				puts "Try again..."
				puts ""
				turn(player_color)
			when :invalid_move
				puts "Error: Invalid move! Try again..."
				puts ""
				turn(player_color)
			else
				turn(opponent_color,move)
			end
		end
	end

	# Displays the current gameboard and pieces
	def display

		row8 = "|    |    |    |    |    |    |    |    |"
		row7 = "|    |    |    |    |    |    |    |    |"
		row6 = "|    |    |    |    |    |    |    |    |"
		row5 = "|    |    |    |    |    |    |    |    |"
		row4 = "|    |    |    |    |    |    |    |    |"
		row3 = "|    |    |    |    |    |    |    |    |"
		row2 = "|    |    |    |    |    |    |    |    |"
		row1 = "|    |    |    |    |    |    |    |    |"

		def line
			"_________________________________________"
		end

		@pieces.each do |piece|
			row = case piece.position[1]
			when 8 then row8
			when 7 then row7
			when 6 then row6
			when 5 then row5
			when 4 then row4
			when 3 then row3
			when 2 then row2
			when 1 then row1
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

		puts "  " + line
		puts "8 " + row8
		puts "  " + line
		puts "7 " + row7
		puts "  " + line
		puts "6 " + row6
		puts "  " + line
		puts "5 " + row5
		puts "  " + line
		puts "4 " + row4
		puts "  " + line
		puts "3 " + row3
		puts "  " + line
		puts "2 " + row2
		puts "  " + line
		puts "1 " + row1
		puts "  " + line
		puts "    A    B    C    D     E    F    G    H  "
	end

	def play_again
		puts ""
		puts "Play again? (\"yes\" or \"no\")"
		input = gets.chomp.downcase.gsub(/\s+/,"")
		case input
		when "yes"
			initialize
		when "no"
		else
			puts "Error: Invalid input! Try again..."
			play_again
		end
	end

	# Initiates move input
	def move_input(color)
		initial_position_input(color)
	end

	# Takes user input for the initial position
	def initial_position_input(color)
		puts ""
		puts "Choose the position of the piece you want to move:"
		initial_position = gets.chomp.upcase.gsub(/\s+/,"")
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
				move = new_position_input(initial_position,color,piece)
			else
				move = :invalid_move
			end
		end
		move
	end

	# Take user input for the new position
	def new_position_input(initial_position,color,piece)
		puts ""
		puts "Choose which position to move your #{piece.type},"
		puts "or choose a different piece by inputting its position:"
		new_position = gets.chomp.upcase.gsub(/\s+/,"")
		case new_position
		when "HELP"
			:help
		when "SAVE"
			:save
		when "EXIT"
			:exit
		when "CASTLE"
			castle(color)
		else
			new_position = new_position.split("")
			new_position = [new_position[0].to_sym,new_position[1].to_i]
			current_piece = @pieces.find { |piece| piece.position == initial_position }
			new_piece = @pieces.find { |piece| piece.position == new_position }
			if new_piece != nil && new_piece.color == color && possible_moves(new_piece) != []
				new_position_input(new_position,color,new_piece)
			else
				status = temporary_move(current_piece,new_position)
				if status == :safe
					move = move_piece(initial_position,new_position)
				else
					move = :unsafe
				end
			end
		end
		move
	end

	# Removes a piece in the given position from the gameboard
	def remove_piece(position)
		@pieces.delete_if { |piece| piece.position == position }
		@gameboard.occupied_spaces.delete_if { |space| space == position }
	end

	# Narrows possible moves based on position of all pieces on the board
	def possible_moves(piece)
		moves_hash = piece.possible_moves
		moves_hash.each do |direction,moves|
			moves.each do |move|
				if piece.type == :king || piece.type == :knight
					if @gameboard.occupied_spaces.include?(move)
						occupier = @pieces.find { |occupier| occupier.position == move }
						moves.pop if occupier.color == piece.color
					end
				elsif piece.type == :queen || piece.type == :bishop || piece.type == :rook
					if @gameboard.occupied_spaces.include?(move)
						moves.pop until moves[-1] == move
						occupier = @pieces.find { |occupier| occupier.position == move }
						moves.pop if occupier.color == piece.color
					end
				elsif piece.type == :pawn
					if direction == :forward
						if @gameboard.occupied_spaces.include?(move)
							moves.pop
							moves_hash[:twiceforward].pop
						end
					elsif direction == :twiceforward
						moves.pop if @gameboard.occupied_spaces.include?(move)
					else
						if @gameboard.occupied_spaces.include?(move)
							occupier = @pieces.find { |occupier| occupier.position == move }
							moves.pop if occupier.color == piece.color
						else
							moves.pop
						end
					end
				end
			end
		end
		moves_hash.values.flatten(1)
	end

	# Allows player to castle
	def castle(color,rook_choice=false)
		row = case color
		when :white
			1
		when :black
			8
		end
		king = @pieces.find { |piece| piece.color == color && piece.type == :king }
		rook_A = @pieces.find { |piece| piece.color == color && piece.type == :rook && piece.position == [:A,row] }
		rook_H = @pieces.find { |piece| piece.color == color && piece.type == :rook && piece.position == [:H,row] }
		rook_A_counter_conditions = rook_A.nil? || rook_A.moving || \
		@gameboard.occupied_spaces.include?([:B,row]) || \
		@gameboard.occupied_spaces.include?([:C,row]) || \
		@gameboard.occupied_spaces.include?([:D,row])
		rook_H_counter_conditions = rook_H.nil? || rook_H.moving || \
		@gameboard.occupied_spaces.include?([:F,row]) || \
		@gameboard.occupied_spaces.include?([:G,row])
		unless king.moving
			unless rook_A_counter_conditions && rook_H_counter_conditions
				if rook_H_counter_conditions || rook_choice == :A
					move_piece(rook_A.position,[:D,row])
					@gameboard.occupied_spaces.delete_if { |space| space == king.position }
					@gameboard.occupied_spaces << [:C,row]
					king.position = [:C,row]
					king.moving = true
				elsif rook_A_counter_conditions || rook_choice == :H
					move_piece(rook_H.position,[:F,row])
					@gameboard.occupied_spaces.delete_if { |space| space == king.position }
					@gameboard.occupied_spaces << [:G,row]
					king.position = [:G,row]
					king.moving = true
				else
					puts ""
					puts "Choose the position of the rook you wish to castle with:"
					rook = gets.chomp.upcase.gsub(/\s+/,"").to_sym
					if rook == :A || rook == :H
						castle(color,rook)
					else
						:invalid_move
					end
				end
			else
				:invalid_move
			end
		else
			:invalid_move
		end
	end

	# Promotes piece to a queen type if it reaches the end of the board
	def promotion(pawn)
		position = pawn.position
		color = pawn.color
		remove_piece(position)
		@pieces << Piece.new(:queen,color,position)
		@gameboard.occupied_spaces << position
	end

	# Moves a piece in a given position to another given position
	# if it is a possible move
	def move_piece(initial_position,new_position)
		piece = @pieces.find { |current_piece| current_piece.position == initial_position }
		occupier = @pieces.find { |current_piece| current_piece.position == new_position }
		if possible_moves(piece).include?(new_position)
			remove_piece(occupier.position) if occupier
			@gameboard.occupied_spaces.delete_if { |space| space == initial_position }
			@gameboard.occupied_spaces << new_position
			piece.position = new_position
			piece.moving = true
			occupier ? occupier.type : nil
		else
			:invalid_move
		end
	end

	def temporary_move(piece,new_position)
		status = nil
		original_position = piece.position
		@gameboard.occupied_spaces.delete_if {|space| space == original_position }
		@gameboard.occupied_spaces << new_position
		opposing_piece = @pieces.find {|opponent| opponent.color != piece.color && opponent.position == new_position}
		@pieces.delete(opposing_piece) if opposing_piece
		piece.position = new_position
		status = :safe if king_status(piece.color,true) == :safe
		@gameboard.occupied_spaces.pop
		@gameboard.occupied_spaces << original_position
		piece.position = original_position
		@pieces << opposing_piece if opposing_piece
		status
	end

	def king_status(player_color,check=false)
		king = @pieces.find { |piece| piece.type == :king && piece.color == player_color }
		status = :safe
		@pieces.each do |piece|
			if piece.color != player_color && possible_moves(piece).include?(king.position)
				status = :check unless piece.type == :pawn && piece.position[1] = king.position[1]
			end
		end
		if status == :check && check == false
			@pieces.each do |piece|
				if piece.color == player_color
					possible_moves(piece).each do |possibility|
						move = temporary_move(piece,possibility)
						return status if move == :safe
					end
				end
			end
			status = :checkmate
		end
		status
	end

	def check_message(color)
		puts ""
		puts "The #{color} king is in check!"
	end

	def checkmate_message(color)
		puts ""
		puts "The #{color} king is in checkmate!"
		puts "Black wins!" if color == :white
		puts "White wins!" if color == :black
	end

end