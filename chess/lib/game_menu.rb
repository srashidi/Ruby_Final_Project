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
			load_menu
		when 3
			puts "Goodbye!"
		else
			puts "Error: Invalid input! Try again..."
			initialize
		end
	end

	# Provides a list of saved games and allows user to choose one to load
	def load_menu
		i = 1
    File.new("saved_games.yaml","w") unless File.exist?("saved_games.yaml")
    if File.read("saved_games.yaml").empty?
      puts "There are no saved games, yet."
      initialize
    else
      YAML.load_stream(File.open("saved_games.yaml")) do |saved_game|
        puts "#{i}: " + saved_game[-1].strftime("%m/%d/%Y %I:%M%P")
        i += 1
      end
      puts ""
      puts "Choose a game to load or \"exit\" to menu:"
      game_index = gets.chomp.strip.downcase
      if game_index == "exit"
        initialize
      elsif game_index.to_i <= i && game_index.to_i >= 1
        game_index = game_index.to_i
        i = 1
        File.new("temp.yaml","w")
        puts ""
        YAML.load_stream(File.open("saved_games.yaml")) do |game|
          if i == game_index
          	@gameboard = game[0]
            @pieces = game[1]
            @player_color = game[2]
          else
            File.open("temp.yaml","a") do |out|
              YAML::dump(game,out)
            end
          end
          i += 1
        end
        File.delete("saved_games.yaml")
        File.rename("temp.yaml","saved_games.yaml")
        Chess.new(@gameboard,@pieces,@player_color)
      else
        puts "Invalid input. Try again..."
        puts ""
        load_menu
      end
    end
	end

end