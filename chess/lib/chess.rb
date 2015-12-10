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
		if saved_info.nil?
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
		puts ""
		puts "During the game, you can \"save\" your game and exit,"
		puts "\"exit\" the game without saving, or ask for \"help\"."
		turn(:white)
	end

	def load_game(saved_info)
	end

	def save_game(player_colorcolor)
		File.open("saved_games.yaml", "a") do |out|
      YAML::dump([@gameboard,@pieces,player_color], out)
    end
	end

	def help
		Launchy.open("https://en.wikipedia.org/wiki/Chess#Rules")
		puts ""
		puts "An explanation of the rules of chess has been opened on"
		puts "your default browser."
		puts "During the game, you can \"save\" your game and exit,"
		puts "\"exit\" the game without saving, or ask for \"help\"."
		puts ""
		puts "Press ENTER when you are ready to continue."
		gets
	end

	def turn(player_color)
		puts ""
		display
		puts ""
		puts "#{player_color.to_s.capitalize}'s turn!"
		move = move_input(player_color)
		turn(player_color) if move == :invalid_move
		puts ""
		case move
		when :help
			help
			turn(player_color)
		when :save
			save_game(player_color)
			puts "Game saved!"
			puts "Goodbye!"
			puts ""
		when :exit
			puts "Goodbye!"
			puts ""
		when :invalid_move
			puts "Error: Invalid move! Try again..."
			puts ""
			turn(player_color)
		else
			turn(:black) if player_color == :white
			turn(:white) if player_color == :black
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
		else
			initial_position = initial_position.split("")
			initial_position = [initial_position[0].to_sym,initial_position[1].to_i]
			piece = @pieces.find { |current_piece| current_piece.position == initial_position }
			if piece != nil && piece.color == color && possible_moves(piece) != []
				move = new_position_input(piece)
			else
				move = :invalid_move
			end
		end
		move
	end

	# Take user input for the new position
	def new_position_input(color,piece)
		puts ""
		puts "Choose which position to move your #{piece.type},"
		puts "or choose a different piece by inputting its position:"
		new_position = gets.chomp.upcase.gsub(/\s+/,"")
		case initial_position
		when "HELP"
			:help
		when "SAVE"
			:save
		when "EXIT"
			:exit
		else
			new_position = new_position.split("")
			new_position = [new_position[0].to_sym,new_position[1].to_i]
			piece = @pieces.find { |current_piece| current_piece.position == new_position }
			if piece != nil && piece.color == color && possible_moves(piece) != []
				new_position_input(color,piece)
			else
				move = move_piece(initial_position,new_position)
			end
		end
		move
	end

	def other_input_options(input)

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

	# Moves a piece in a given position to another given position
	# if it is a possible move
	def move_piece(initial_position,new_position)
		piece = @pieces.find { |current_piece| current_piece.position == initial_position }
		occupier = @pieces.find { |current_piece| current_piece.position == new_position }
		if possible_moves(piece).include?(new_position)
			if occupier
				puts ""
				string = occupier.type == :queen ? "The " : "A "
				puts string + "#{occupier.color} #{occupier.type} has been captured!"
				puts ""
				remove_piece(occupier.position)
			end
			@gameboard.occupied_spaces.delete_if { |space| space == initial_position }
			@gameboard.occupied_spaces << new_position
			piece.position = new_position
		else
			:invalid_move
		end
	end

end