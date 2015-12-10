require_relative './chess'

class GameMenu

	# Allows user to choose to start a new game, load a saved game, or exit
	def initialize
		puts ""
		puts "Choose from the following options (input \"1\",\"2\", or \"3\"):"
		puts "1: Start a new game"
		puts "2: Load a saved game"
		puts "3: Exit"
		choice = gets.chomp.strip.to_i
		puts ""
		case choice
		when 1
			Chess.new
		when 2
			load_game
		when 3
			puts "Goodbye!"
		else
			puts "Error: Invalid input! Try again..."
			initialize
		end
	end

end